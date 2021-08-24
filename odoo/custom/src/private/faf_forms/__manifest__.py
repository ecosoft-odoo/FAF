# Copyright 2021 Ecosoft Co., Ltd. (http://ecosoft.co.th)
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl.html).

{
    "name": "FAF - Forms",
    "summary": "FAF Forms",
    "version": "14.0.1.0.0",
    "category": "FAF",
    "website": "http://ecosoft.co.th",
    "author": "Tharathip C., Ecosoft",
    "depends": [
        "faf_base",
        "faf_sale",
        "faf_sale_service_template",
        "faf_hr_salesperson",
    ],
    "data": [
        "data/paperformat_data.xml",
        "data/report_data.xml",
        "report/quotation_form.xml",
        "report/invoice_form.xml",
        "report/receipt_tax_invoice_form.xml",
        "report/receipt_form.xml",
        "views/assets.xml",
    ],
    "license": "AGPL-3",
    "installable": True,
    "maintainers": ["newtratip"],
}
