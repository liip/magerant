# Default Apache virtualhost template

<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName {{ hostname }}

    <Directory {{ doc_root }}>
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
