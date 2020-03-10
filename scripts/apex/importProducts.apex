String productsJson = '{0}';

Product2[] products = new Product2[]{};
for(Product2 p : (Product2[])JSON.deserialize(productsJson, Product2[].class)) {
    System.debug('Prod: ['+p.Name+']');
    products.add(p);
}
System.debug('Importing ['+products.size()+'] Products');
if(!products.isEmpty()) {
    Database.upsert(products, Product2.fields.Id, true);
}