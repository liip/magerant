<?php

if (file_exists('./app/etc/local.xml'))
{
    $xml = simplexml_load_file('./app/etc/local.xml');

    $global = $xml->global;
    //die(var_dump($global->session_save_path->saveXML()));
    if (!$global->session_save_path->saveXML())
    {
        $global->addChild('session_save_path', '<![CDATA[/tmp]]>');
        //die(var_dump( $xml->saveXML()));
        $xmlOutput = $xml->saveXML();
        print_r(file_put_contents('./app/etc/local.xml', html_entity_decode($xmlOutput)));

    }

    include_once('./app/Mage.php');

    $app = Mage::app();

    if($app != null)
    {
        $cache = $app->getCache();
        if($cache != null)
        {
            $cache->clean();
            echo "cleaned cache";
        }
    }
}
else
{
    exit('Failed to open local.xml.');
}

