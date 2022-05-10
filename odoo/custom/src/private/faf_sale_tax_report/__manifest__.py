# Copyright 2022 Ecosoft Co., Ltd (https://ecosoft.co.th)
# License AGPL-3.0 or later (https://www.gnu.org/licenses/agpl.html)

{
    "name": "FAF - Sale Tax Report",
    "version": "14.0.1.0.0",
    "author": "Ecosoft, Odoo Community Association (OCA)",
    "website": "http://ecosoft.co.th",
    "license": "AGPL-3",
    "category": "Accounting",
    "depends": [
        "account",
        "date_range",
        "report_xlsx_helper",
    ],
    "data": [
        "security/ir.model.access.csv",
        "data/paper_format.xml",
        "data/report_data.xml",
        "reports/sale_tax_report.xml",
        "wizard/sale_tax_report_wizard_view.xml",
    ],
    "installable": True,
    "maintainers": ["newtratip"],
}
