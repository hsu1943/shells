#!/bin/bash
DATE=`date +%m%d`
echo
read -n 15 -p "请输入数据库名称：" DATABASE

if [ ! -d  "/ssd1/mysql_dump_tmp/$DATE/" ]; then mkdir "/ssd1/mysql_dump_tmp/$DATE/"; fi

echo ""
echo "====================================="
echo "数据库 $DATABASE 导出中..."
# 导出整个数据库
# mysqldump -h127.0.0.1 -uroot -pPASSWORD --databases $DATABASE > /ssd1/mysql_dump_tmp/$DATABASE.sql


# 导出数据库中的数据和表结构
# mysqldump -h127.0.0.1 -uroot -pPASSWORD  $DATABASE > /ssd1/mysql_dump_tmp/$DATE/$DATABASE.sql
# echo "====================================="
# echo "数据库 $DATABASE 导出成功"
# sleep 5

# 导出数据库中的数据和表结构并忽略某些表
mysqldump -d $DATABASE -h127.0.0.1 -uroot -pPASSWORD  > /ssd1/mysql_dump_tmp/$DATE/$DATABASE.sql
mysqldump -h127.0.0.1 -uroot -pPASSWORD -t $DATABASE --ignore-table==accumulation_material_attach --ignore-table=accumulation_material_result --ignore-table=accumulation_material --ignore-table=action_log --ignore-table=aicheck_log --ignore-table=assist_applicant --ignore-table=assist_applicant_has_patient --ignore-table=assist_applicant_has_patient_log --ignore-table=attachment_of_phase --ignore-table=attachment_result --ignore-table=attach_check_repeat --ignore-table=attach_compare --ignore-table=attach_compare_log --ignore-table=attach_download --ignore-table=attach_download_history --ignore-table=attach_ocr_data --ignore-table=attach_ocr_log --ignore-table=audit_cancel_log --ignore-table=audit_log --ignore-table=audit_order --ignore-table=autocheck_attach --ignore-table=autocheck_attach_bind --ignore-table=autocheck_log --ignore-table=autocheck_review --ignore-table=autocheck_review_log --ignore-table=check_attach_extra --ignore-table=check_attach_group --ignore-table=check_attach_group_alias --ignore-table=check_attach_group_invoice --ignore-table=check_attach_info --ignore-table=check_attach_match --ignore-table=check_attach_match_log --ignore-table=check_attach_match_result --ignore-table=check_attach_statistics --ignore-table=check_attach_verify --ignore-table=check_item_aicheck_order --ignore-table=check_item_airesult --ignore-table=check_item_aireview --ignore-table=check_item_attach --ignore-table=check_item_attach_field --ignore-table=check_item_invoice --ignore-table=check_item_invoice_drugs --ignore-table=check_item_operation_guide --ignore-table=check_item_operation_guide_attach --ignore-table=check_item_report --ignore-table=check_item_report_save --ignore-table=check_item_result --ignore-table=family --ignore-table=id_card_log --ignore-table=invoice --ignore-table=invoice_data_log --ignore-table=invoice_drugs --ignore-table=invoice_log --ignore-table=invoice_ocr_log --ignore-table=invoice_verify_task --ignore-table=login_log --ignore-table=package_produce_log --ignore-table=patient --ignore-table=patient_aicheck --ignore-table=patient_aicheck_order --ignore-table=patient_change_log --ignore-table=patient_check_log --ignore-table=patient_info --ignore-table=patient_log --ignore-table=patient_prefer_city --ignore-table=patient_process --ignore-table=patient_process_log --ignore-table=patient_remark_log --ignore-table=patient_takeover_log --ignore-table=phase --ignore-table=phase_check_count --ignore-table=phase_check_log --ignore-table=phase_drug --ignore-table=phase_drug_field --ignore-table=phase_info --ignore-table=phase_log --ignore-table=phase_time --ignore-table=predict --ignore-table=predict_change_log --ignore-table=predict_drug --ignore-table=predict_first_date --ignore-table=predict_return --ignore-table=predict_unlock --ignore-table=predict_unlock_attach --ignore-table=receive --ignore-table=receive_change_log --ignore-table=receive_del_log --ignore-table=receive_drug --ignore-table=receive_drug_batch --ignore-table=receive_drug_code --ignore-table=receive_photo --ignore-table=receive_review_log --ignore-table=referral --ignore-table=referral_apply --ignore-table=report_download_log --ignore-table=report_file --ignore-table=report_task --ignore-table=signature --ignore-table=sms --ignore-table=sms_set_relation --ignore-table=wechat_notification --ignore-table=wechat_notification_others --ignore-table=xlc_invoice_timeout --ignore-table=phase_recipel --ignore-table=phase_recipel_drug --ignore-table=predict_validate_record --ignore-table=intelligent_drugs_order --ignore-table=intelligent_drugs_order_batch --ignore-table=intelligent_drugs_order_log --ignore-table=intelligent_drugs_set --ignore-table=patient_delete_record --ignore-table=consultant_doctor_allocation_log --ignore-table=consultant_doctor_patient --ignore-table=consultant_doctor_patient_log --ignore-table=consultant_doctor_patient_material --ignore-table=package_post --ignore-table=package_produce_log --ignore-table=package_recycle_attach --ignore-table=package_recycle_log --ignore-table=services_change_log --ignore-table=services_has_patient --ignore-table=tpl_notice_log --ignore-table=transient_status_item_result --ignore-table=transient_status_record --ignore-table=transient_status_result_file --ignore-table=api_call_record --ignore-table=call --ignore-table=express --ignore-table=express_api_log --ignore-table=fkw_yyc_express_log --ignore-table=maintain_update_log --ignore-table=material_review_log --ignore-table=patient_document_feedback --ignore-table=aicheck_feedback --ignore-table=async_report_task --ignore-table=check_item_file_result --ignore-table=patient_return_visit --ignore-table=patient_return_visit_attach --ignore-table=volunteer_patient_service --ignore-table=volunteer_patient_vist >> /ssd1/mysql_dump_tmp/$DATE/$DATABASE.sql
echo "====================================="
echo "数据库 $DATABASE 导出成功"
sleep 5


echo "====================================="
echo "资料打包中..."
tar zcvf /ssd1/mysql_dump_tmp/$DATE/$DATABASE.tar -C/alidata1/xc_tmp/$DATE/ $DATABASE.sql
echo "====================================="
echo "打包成功"

rm /ssd1/mysql_dump_tmp/$DATE/$DATABASE.sql
#sz /ssd1/mysql_dump_tmp/$DATABASE.tar

ssh root@172.16.141.50 """if [ ! -d  "/alidata1/xc_tmp/$DATA/" ]; then mkdir "/alidata1/xc_tmp/$DATA/"; fi"""

echo "====================================="
echo "文件传输中"
scp -r /ssd1/mysql_dump_tmp/$DATE/$DATABASE.tar  root@172.16.141.50:/alidata1/xc_tmp/$DATA/
#sz /ssd1/mysql_dump_tmp/$DATABASE.tar
echo "====================================="
echo "文件传输完成"

rm /ssd1/mysql_dump_tmp/$DATE/$DATABASE.tar
echo "====================================="
echo "环境清理成功，程序退出"


exit 0
