<?php
//included from /usr/local/zend/share/phpmyadmin/config.inc.php

$cfg['TitleDefault'] = '@VERBOSE@ @DATABASE@ @TABLE@';
$cfg['blowfish_secret'] = 'eam wuddai yam';

//localhost
$i = 1;
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = 'pavCAN7';
//see ./Documentation.html#linked-tables
//run ./scripts/create_tables.sql
$cfg['Servers'][$i]['pmadb']           = 'pma';
$cfg['Servers'][$i]['controluser']     = 'pma';
$cfg['Servers'][$i]['controlpass']     = 'XePXF93sN849wxmh';
$cfg['Servers'][$i]['bookmarktable']   = 'pma_bookmark';
$cfg['Servers'][$i]['column_info']     = 'pma_column_info';//
$cfg['Servers'][$i]['designer_coords'] = 'pma_designer_coords';
$cfg['Servers'][$i]['history']         = 'pma_history';
$cfg['Servers'][$i]['pdf_pages']       = 'pma_pdf_pages';//
$cfg['Servers'][$i]['relation']        = 'pma_relation';//
$cfg['Servers'][$i]['table_coords']    = 'pma_table_coords';//
$cfg['Servers'][$i]['table_info']      = 'pma_table_info';//

//dev-db.medu.com
$i++;
$cfg['Servers'][$i]['auth_type'] = 'config';//cookie|config
$cfg['Servers'][$i]['user'] = 'medu_user';
$cfg['Servers'][$i]['password'] = 'pl@sT1qu3';
$cfg['Servers'][$i]['host'] = 'dev-db.medu.com';
$cfg['Servers'][$i]['verbose'] = 'dev-db.medu.com';
$cfg['Servers'][$i]['connect_type'] = 'tcp';//socket|tcp
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['extension'] = 'mysql';
