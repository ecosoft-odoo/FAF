#!/bin/bash
psql -U odoo uspphuket << EOF
-- delete transaction
delete from account_full_reconcile;
delete from account_partial_reconcile;
delete from account_move_line;
delete from account_move;
delete from account_move_tax_invoice;
delete from withholding_tax_cert_line;
delete from withholding_tax_cert;
delete from account_payment;
delete from project_task;
delete from project_project;
delete from project_task_type;
delete from sale_order_line;
delete from sale_order;
delete from purchase_order_line;
delete from purchase_order;
delete from account_analytic_line;
delete from account_analytic_account;
-- delete mail message
delete from mail_message where model = 'account.analytic.account' and res_id not in (select id from account_analytic_account);
delete from mail_message where model = 'account.move' and res_id not in (select id from account_move);
delete from mail_message where model = 'account.payment' and res_id not in (select id from account_payment);
delete from mail_message where model = 'crm.team' and res_id not in (select id from crm_team);
delete from mail_message where model = 'hr.department' and res_id not in (select id from hr_department);
delete from mail_message where model = 'hr.employee' and res_id not in (select id from hr_employee);
delete from mail_message where model = 'mail.channel' and res_id not in (select id from mail_channel);
delete from mail_message where model = 'product.product' and res_id not in (select id from product_product);
delete from mail_message where model = 'product.template' and res_id not in (select id from product_template);
delete from mail_message where model = 'project.project' and res_id not in (select id from project_project);
delete from mail_message where model = 'project.task' and res_id not in (select id from project_task);
delete from mail_message where model = 'purchase.order' and res_id not in (select id from purchase_order);
delete from mail_message where model = 'res.partner' and res_id not in (select id from res_partner);
delete from mail_message where model = 'sale.order' and res_id not in (select id from sale_order);
delete from mail_message where model = 'withholding.tax.cert' and res_id not in (select id from withholding_tax_cert);
delete from mail_message where model is Null;
-- delete mail tracking
delete from mail_tracking_value where mail_message_id not in (select id from mail_message);
-- delete mail follower
delete from mail_followers where res_model = 'account.analytic.account' and res_id not in (select id from account_analytic_account);
delete from mail_followers where res_model = 'account.journal' and res_id not in (select id from account_journal);
delete from mail_followers where res_model = 'account.move' and res_id not in (select id from account_move);
delete from mail_followers where res_model = 'account.payment' and res_id not in (select id from account_payment);
delete from mail_followers where res_model = 'hr.employee' and res_id not in (select id from hr_employee);
delete from mail_followers where res_model = 'mail.channel' and res_id not in (select id from mail_channel);
delete from mail_followers where res_model = 'product.product' and res_id not in (select id from product_product);
delete from mail_followers where res_model = 'product.template' and res_id not in (select id from product_template);
delete from mail_followers where res_model = 'project.task' and res_id not in (select id from project_task);
delete from mail_followers where res_model = 'purchase.order' and res_id not in (select id from purchase_order);
delete from mail_followers where res_model = 'res.partner' and res_id not in (select id from res_partner);
delete from mail_followers where res_model = 'sale.order' and res_id not in (select id from sale_order);
delete from mail_followers where res_model = 'withholding.tax.cert' and res_id not in (select id from withholding_tax_cert);
-- delete mail
delete from mail_mail;
-- delete external identifiers
delete from ir_model_data where model = 'account.account' and res_id not in (select id from account_account);
delete from ir_model_data where model = 'account.account.tag' and res_id not in (select id from account_account_tag);
delete from ir_model_data where model = 'account.account.template' and res_id not in (select id from account_account_template);
delete from ir_model_data where model = 'account.account.type' and res_id not in (select id from account_account_type);
delete from ir_model_data where model = 'account.chart.template' and res_id not in (select id from account_chart_template);
delete from ir_model_data where model = 'account.edi.format' and res_id not in (select id from account_edi_format);
delete from ir_model_data where model = 'account.financial.html.report' and res_id not in (select id from account_financial_html_report);
delete from ir_model_data where model = 'account.financial.html.report.line' and res_id not in (select id from account_financial_html_report_line);
delete from ir_model_data where model = 'account.incoterms' and res_id not in (select id from account_incoterms);
delete from ir_model_data where model = 'account.payment.method' and res_id not in (select id from account_payment_method);
delete from ir_model_data where model = 'account.payment.term' and res_id not in (select id from account_payment_term);
delete from ir_model_data where model = 'account.tax' and res_id not in (select id from account_tax);
delete from ir_model_data where model = 'account.tax.group' and res_id not in (select id from account_tax_group);
delete from ir_model_data where model = 'account.tax.report' and res_id not in (select id from account_tax_report);
delete from ir_model_data where model = 'account.tax.report.line' and res_id not in (select id from account_tax_report_line);
delete from ir_model_data where model = 'account.tax.template' and res_id not in (select id from account_tax_template);
delete from ir_model_data where model = 'account_followup.followup.line' and res_id not in (select id from account_followup_followup_line);
delete from ir_model_data where model = 'barcode.nomenclature' and res_id not in (select id from barcode_nomenclature);
delete from ir_model_data where model = 'barcode.rule' and res_id not in (select id from barcode_rule);
delete from ir_model_data where model = 'crm.team' and res_id not in (select id from crm_team);
delete from ir_model_data where model = 'decimal.precision' and res_id not in (select id from decimal_precision);
delete from ir_model_data where model = 'digest.digest' and res_id not in (select id from digest_digest);
delete from ir_model_data where model = 'digest.tip' and res_id not in (select id from digest_tip);
delete from ir_model_data where model = 'hr.department' and res_id not in (select id from hr_department);
delete from ir_model_data where model = 'hr.employee' and res_id not in (select id from hr_employee);
delete from ir_model_data where model = 'hr.plan' and res_id not in (select id from hr_plan);
delete from ir_model_data where model = 'hr.plan.activity.type' and res_id not in (select id from hr_plan_activity_type);
delete from ir_model_data where model = 'mail.activity.type' and res_id not in (select id from mail_activity_type);
delete from ir_model_data where model = 'mail.alias' and res_id not in (select id from mail_alias);
delete from ir_model_data where model = 'mail.channel' and res_id not in (select id from mail_channel);
delete from ir_model_data where model = 'mail.message' and res_id not in (select id from mail_message);
delete from ir_model_data where model = 'mail.message.subtype' and res_id not in (select id from mail_message_subtype);
delete from ir_model_data where model = 'mail.template' and res_id not in (select id from mail_template);
delete from ir_model_data where model = 'payment.acquirer' and res_id not in (select id from payment_acquirer);
delete from ir_model_data where model = 'payment.icon' and res_id not in (select id from payment_icon);
delete from ir_model_data where model = 'product.category' and res_id not in (select id from product_category);
delete from ir_model_data where model = 'product.pricelist' and res_id not in (select id from product_pricelist);
delete from ir_model_data where model = 'product.product' and res_id not in (select id from product_product);
delete from ir_model_data where model = 'product.template' and res_id not in (select id from product_template);
delete from ir_model_data where model = 'project.project' and res_id not in (select id from project_project);
delete from ir_model_data where model = 'project.status' and res_id not in (select id from project_status);
delete from ir_model_data where model = 'project.task' and res_id not in (select id from project_task);
delete from ir_model_data where model = 'report.layout' and res_id not in (select id from report_layout);
delete from ir_model_data where model = 'report.paperformat' and res_id not in (select id from report_paperformat);
delete from ir_model_data where model = 'res.bank' and res_id not in (select id from res_bank);
delete from ir_model_data where model = 'res.company' and res_id not in (select id from res_company);
delete from ir_model_data where model = 'res.country' and res_id not in (select id from res_country);
delete from ir_model_data where model = 'res.country.group' and res_id not in (select id from res_country_group);
delete from ir_model_data where model = 'res.country.state' and res_id not in (select id from res_country_state);
delete from ir_model_data where model = 'res.currency' and res_id not in (select id from res_currency);
delete from ir_model_data where model = 'res.groups' and res_id not in (select id from res_groups);
delete from ir_model_data where model = 'res.lang' and res_id not in (select id from res_lang);
delete from ir_model_data where model = 'res.partner' and res_id not in (select id from res_partner);
delete from ir_model_data where model = 'res.partner.company.type' and res_id not in (select id from res_partner_company_type);
delete from ir_model_data where model = 'res.partner.industry' and res_id not in (select id from res_partner_industry);
delete from ir_model_data where model = 'res.partner.title' and res_id not in (select id from res_partner_title);
delete from ir_model_data where model = 'res.users' and res_id not in (select id from res_users);
delete from ir_model_data where model = 'resource.calendar' and res_id not in (select id from resource_calendar);
delete from ir_model_data where model = 'sale.order.type' and res_id not in (select id from sale_order_type);
delete from ir_model_data where model = 'uom.category' and res_id not in (select id from uom_category);
delete from ir_model_data where model = 'uom.uom' and res_id not in (select id from uom_uom);
delete from ir_model_data where model = 'utm.medium' and res_id not in (select id from utm_medium);
delete from ir_model_data where model = 'utm.source' and res_id not in (select id from utm_source);
delete from ir_model_data where model = 'utm.stage' and res_id not in (select id from utm_stage);
delete from ir_model_data where model = 'utm.tag' and res_id not in (select id from utm_tag);
EOF
