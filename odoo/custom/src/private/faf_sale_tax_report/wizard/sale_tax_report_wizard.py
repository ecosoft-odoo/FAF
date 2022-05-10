# Copyright 2022 Ecosoft Co., Ltd (https://ecosoft.co.th)
# License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html)

from odoo import api, fields, models
from odoo.tools.safe_eval import safe_eval


class SaleTaxReportWizard(models.TransientModel):
    _name = "sale.tax.report.wizard"
    _description = "Wizard for Sale Tax Report"

    # Search Criteria
    date_range_id = fields.Many2one(
        comodel_name="date.range",
        string="Period",
    )
    date_from = fields.Date(
        string="Date From",
    )
    date_to = fields.Date(
        string="Date To",
    )
    journal_id = fields.Many2one(
        comodel_name="account.journal",
        string="Journal",
    )
    results = fields.Many2many(
        comodel_name="account.payment",
        compute="_compute_results",
        help="Use compute fields, so there is nothing store in database",
    )

    def _compute_results(self):
        self.ensure_one()
        Payment = self.env["account.payment"]
        dom = [
            ("state", "=", "posted"),
            ("partner_type", "=", "customer"),
            ("is_internal_transfer", "=", False),
        ]
        if self.date_from:
            dom += [("date", ">=", self.date_from)]
        if self.date_to:
            dom += [("date", "<=", self.date_to)]
        if self.journal_id:
            dom += [("journal_id", "=", self.journal_id.id)]
        self.results = Payment.search(dom)

    @api.onchange("date_range_id")
    def _onchange_date_range_id(self):
        date_range = self.date_range_id
        if date_range:
            self.update(
                {
                    "date_from": date_range.date_start,
                    "date_to": date_range.date_end,
                }
            )

    def print_report(self, report_type="qweb"):
        self.ensure_one()
        action = (
            report_type == "xlsx"
            and self.env.ref("faf_sale_tax_report.action_sale_tax_report_xlsx")
            or self.env.ref("faf_sale_tax_report.action_sale_tax_report_pdf")
        )
        return action.report_action(self, config=False)

    def _get_html(self):
        result = {}
        rcontext = {}
        context = dict(self.env.context)
        report = self.browse(context.get("active_id"))
        if report:
            rcontext["o"] = report
            result["html"] = self.env.ref(
                "faf_sale_tax_report.report_sale_tax_report_html"
            )._render(rcontext)
        return result

    @api.model
    def get_html(self, given_context=None):
        return self.with_context(given_context)._get_html()

    def button_export_html(self):
        self.ensure_one()
        action = self.env.ref("faf_sale_tax_report.action_sale_tax_report_html")
        vals = action.read()[0]
        context = vals.get("context", {})
        if context:
            context = safe_eval(context)
        context["active_id"] = self.id
        context["active_ids"] = self.ids
        vals["context"] = context
        return vals

    def button_export_pdf(self):
        self.ensure_one()
        report_type = "qweb-pdf"
        return self.print_report(report_type)

    def button_export_xlsx(self):
        self.ensure_one()
        report_type = "xlsx"
        return self.print_report(report_type)
