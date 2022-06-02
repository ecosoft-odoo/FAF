# Copyright 2022 Ecosoft Co., Ltd (https://ecosoft.co.th)
# License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html)

from odoo import models

from odoo.addons.report_xlsx_helper.report.report_xlsx_format import (
    FORMATS,
    XLS_HEADERS,
)


class ReportSaleTaxReportXlsx(models.TransientModel):
    _name = "report.faf_sale_tax_report.report_sale_tax_report_xlsx"
    _inherit = "report.report_xlsx.abstract"
    _description = "Sale Tax Report Excel"

    def _get_ws_params(self, wb, data, objects):
        sale_tax_template = {
            "01_index": {
                "header": {"value": "No."},
                "data": {"value": self._render("row_pos")},
                "width": 5,
            },
            "02_date": {
                "header": {"value": "Date"},
                "data": {"value": self._render("date")},
                "width": 12,
            },
            "03_number": {
                "header": {"value": "Number"},
                "data": {"value": self._render("number")},
                "width": 18,
            },
            "04_partner_name": {
                "header": {"value": "Customer"},
                "data": {"value": self._render("partner_name")},
                "width": 30,
            },
            "05_partner_vat": {
                "header": {"value": "Tax ID"},
                "data": {"value": self._render("partner_vat")},
                "width": 15,
            },
            "06_partner_branch": {
                "header": {"value": "Branch ID"},
                "data": {"value": self._render("partner_branch")},
                "width": 12,
            },
            "07_base_no_vat": {
                "header": {"value": "Non Vat"},
                "data": {
                    "value": self._render("base_no_vat"),
                    "format": FORMATS["format_tcell_amount_right"],
                },
                "width": 21,
            },
            "08_base_vat": {
                "header": {"value": "Base Amount"},
                "data": {
                    "value": self._render("base_vat"),
                    "format": FORMATS["format_tcell_amount_right"],
                },
                "width": 21,
            },
            "09_tax_amount": {
                "header": {"value": "Tax Amount"},
                "data": {
                    "value": self._render("tax_amount"),
                    "format": FORMATS["format_tcell_amount_right"],
                },
                "width": 21,
            },
            "10_total": {
                "header": {"value": "Total"},
                "data": {
                    "value": self._render("total"),
                    "format": FORMATS["format_tcell_amount_right"],
                },
                "width": 21,
            },
            "11_doc_ref": {
                "header": {"value": "Doc Ref."},
                "data": {"value": self._render("doc_ref")},
                "width": 18,
            },
        }
        ws_params = {
            "ws_name": "Sale Tax Report",
            "generate_ws_method": "_sale_tax_report",
            "title": "Sale Tax Report",
            "wanted_list": [k for k in sorted(sale_tax_template.keys())],
            "col_specs": sale_tax_template,
        }
        return [ws_params]

    def _sale_tax_report(self, wb, ws, ws_params, data, objects):
        ws.set_portrait()
        ws.fit_to_pages(1, 0)
        ws.set_header(XLS_HEADERS["xls_headers"]["standard"])
        ws.set_footer(XLS_HEADERS["xls_footers"]["standard"])
        self._set_column_width(ws, ws_params)
        row_pos = 0
        # title
        row_pos = self._write_ws_title(ws, row_pos, ws_params, True)
        # company data
        company = objects.env.company
        ws.write_column(
            row_pos,
            1,
            ["Partner :", "Tax ID :", "Branch ID :"],
            FORMATS["format_left_bold"],
        )
        ws.write_column(
            row_pos,
            2,
            [
                (company.display_name) or "",
                (company.partner_id.vat) or "",
                (company.partner_id.branch) or "",
            ],
        )
        ws.write_column(
            row_pos,
            5,
            ["Period :", "Date From :", "Date To :", "Journal :"],
            FORMATS["format_left_bold"],
        )
        ws.write_column(
            row_pos,
            6,
            [
                (objects.date_range_id.name) or "",
                (objects.date_from.strftime("%d/%m/%Y")) or "",
                (objects.date_to.strftime("%d/%m/%Y")) or "",
                (objects.journal_id.name) or "",
            ],
        )
        row_pos += 5
        # sale tax report table
        row_pos = self._write_line(
            ws,
            row_pos,
            ws_params,
            col_specs_section="header",
            default_format=FORMATS["format_theader_blue_left"],
        )
        ws.freeze_panes(row_pos, 0)
        for obj in objects:
            total_base_no_vat = 0.00
            total_base_vat = 0.00
            total_tax_amount = 0.00
            for line in obj.results:
                # Get all account.move
                full_reconcile = line.move_id.line_ids.mapped("full_reconcile_id")
                if full_reconcile and len(full_reconcile) == 1:
                    moves = full_reconcile.reconciled_line_ids.filtered(
                        lambda l: l.move_id != line.move_id
                    ).mapped("move_id")
                else:
                    moves = line.env["account.move"]
                    for rec in line.move_id._get_reconciled_invoices_partials():
                        moves |= rec[2].move_id
                # Calculate Base No Vat, Base Vat, Tax Amount
                inv_lines = moves.mapped("invoice_line_ids")
                base_no_vat_inv_lines = inv_lines.filtered(
                    lambda k: not k.tax_ids
                    or not k.tax_ids.filtered(lambda l: l.amount)
                )
                base_vat_inv_lines = inv_lines.filtered(
                    lambda k: k.tax_ids and k.tax_ids.filtered(lambda l: l.amount)
                )
                base_no_vat = sum(
                    [
                        (line.move_id.move_type == "out_refund" and -1 or 1)
                        * line.quantity
                        * line.price_unit
                        for line in base_no_vat_inv_lines
                    ]
                )
                base_vat = sum(
                    [
                        (line.move_id.move_type == "out_refund" and -1 or 1)
                        * line.quantity
                        * line.price_unit
                        for line in base_vat_inv_lines
                    ]
                )
                tax_amount = sum(
                    [
                        (move.move_type == "out_refund" and -1 or 1) * move.amount_tax
                        for move in moves
                    ]
                )
                total_base_no_vat += base_no_vat
                total_base_vat += base_vat
                total_tax_amount += tax_amount
                # Write line
                row_pos = self._write_line(
                    ws,
                    row_pos,
                    ws_params,
                    col_specs_section="data",
                    render_space={
                        "row_pos": row_pos - 7,
                        "date": line.date.strftime("%d/%m/%Y") or "",
                        "number": line.name or "",
                        "partner_name": line.partner_id.name or "",
                        "partner_vat": line.partner_id.vat or "",
                        "partner_branch": line.partner_id.branch or "",
                        "base_no_vat": base_no_vat,
                        "base_vat": base_vat,
                        "tax_amount": tax_amount,
                        "total": base_no_vat + base_vat + tax_amount,
                        "doc_ref": ", ".join(moves.mapped("name")),
                    },
                    default_format=FORMATS["format_tcell_left"],
                )
        ws.write_row(
            row_pos,
            6,
            [
                total_base_no_vat,
                total_base_vat,
                total_tax_amount,
                total_base_no_vat + total_base_vat + total_tax_amount,
            ],
            FORMATS["format_theader_blue_amount_right"],
        )
