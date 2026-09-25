#!/bin/bash

dnf update -y
dnf install -y nginx

systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Cloud Operations POC</title>
</head>
<body>
    <h1>Cloud Operations & Automation POC</h1>
    <p>Deployed automatically using Terraform and EC2 User Data.</p>
</body>
</html>
EOF