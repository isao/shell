<?php
/* vim: set expandtab sw=4 ts=4 sts=4: */

/**
 * phpMyAdmin sample configuration, you can use it as base for
 * manual configuration. For easier setup you can use setup/
 *
 * All directives are explained in Documentation.html and on phpMyAdmin
 * wiki <http://wiki.cihar.com>.
 *
 * @version $Id: config.sample.inc.php 11781 2008-11-06 05:29:28Z rajkissu $
 */

/*
 * This is needed for cookie based authentication to encrypt password in
 * cookie
 */
$cfg['blowfish_secret'] = 'ohai i noes';
$cfg['PmaAbsoluteUri'] = 'http://localhost/pma/';
$cfg['McryptDisableWarning'] = true;
$cfg['PmaNoRelation_DisableWarning'] = false;

$cfg['TitleDefault'] = '@VERBOSE@ @DATABASE@ @TABLE@';

/*
 * Servers configuration
 */
$i = 0;


/*
 * LOCALHOST
 */
$i++;
$cfg['Servers'][$i]['auth_type'] = 'config';//cookie|config
$cfg['Servers'][$i]['user'] = 'isao';
$cfg['Servers'][$i]['password'] = 'pavCAN7';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['verbose'] = 'chachbook';
$cfg['Servers'][$i]['connect_type'] = 'socket';//socket|tcp
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['extension'] = 'mysqli';

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


/*
 * STAGE
$i++;
$cfg['Servers'][$i]['user'] = 'isao';
$cfg['Servers'][$i]['password'] = 'pavCAN7';
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['host'] = 'stage';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['extension'] = 'mysql';
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
$cfg['Servers'][$i]['controluser'] = 'pma';
$cfg['Servers'][$i]['controlpass'] = 'LSZ4833CKYrD4PnG';
$cfg['Servers'][$i]['bookmarktable'] = 'pma_bookmark';
$cfg['Servers'][$i]['column_info'] = 'pma_column_info';
$cfg['Servers'][$i]['designer_coords'] = 'pma_designer_coords';
$cfg['Servers'][$i]['history'] = 'pma_history';
$cfg['Servers'][$i]['pdf_pages'] = 'pma_pdf_pages';
$cfg['Servers'][$i]['relation'] = 'pma_relation';
$cfg['Servers'][$i]['table_coords'] = 'pma_table_coords';
$cfg['Servers'][$i]['table_info'] = 'pma_table_info';
 */


/* rajk - for blobstreaming */
#$cfg['Servers'][$i]['bs_garbage_threshold'] = 50;
#$cfg['Servers'][$i]['bs_repository_threshold'] = '32M';
#$cfg['Servers'][$i]['bs_temp_blob_timeout'] = 600;
#$cfg['Servers'][$i]['bs_temp_log_threshold'] = '32M';


/*
 * End of servers configuration
 */

/*
 * Directories for saving/loading files from server
 */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
