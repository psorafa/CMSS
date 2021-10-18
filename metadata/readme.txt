Nasazení Audiences přes MDAPI

Postupoval jsem podle tohoto návodu:  https://www.jitendrazaa.com/blog/salesforce/using-salesforcedx-sfdx-with-non-scratch-orgs/

Složka "metadata" je v sfdxignore

Deploy na dev jsem provedl tímto příkazem:

1) $ sfdx force:mdapi:deploy -f metadata/unpackaged.zip -u dev  -w 10 --ignorewarnings (Ignore warnings - kvůli IDs listviews atd. na Hompeage, jak to máme i ve skriptech pro validaci)

2) na základě doporučení z Know issue, je během nasazení dobré dát soubory *.audience do .forceignore (dal jsem tam celou složku "metadata")

https://trailblazer.salesforce.com/issues_view?id=a1p4V000001lSblQAE&title=audience-metadata-type-not-supported-in-salesforce-cli





