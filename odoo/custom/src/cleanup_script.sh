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
EOF
