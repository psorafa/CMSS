To export data:

1. delete all files and folders in data/core-data, except for export.json and readme-export.txt
2. run following command:
    sfdx sfdmu:run -p data/core-data -u csvfile -s SOURCE

SOURCE stands for username or alias of source org

note: you'll need sfdmu plugin installed:
    sfdx plugins:install sfdmu
