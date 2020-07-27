SET default_storage_engine=INNODB;
create schema if not exists dados;
create table if not exists dados.product_category_name_translation(
	product_category_name VARCHAR(256),
	product_category_name_english VARCHAR(256),
    primary key (product_category_name)
);
create table if not exists dados.olist_geolocation_dataset(
    geolocation_temp_id int auto_increment not null,
    geolocation_zip_code_prefix int(5) not null,
	geolocation_lat decimal(32,16),
	geolocation_lng decimal(32,16),
	geolocation_city varchar(64),
	geolocation_state varchar(2),
    primary key (geolocation_temp_id)
);
create table if not exists dados.olist_customers_dataset(
	customer_id BINARY(32) not null,
	customer_unique_id BINARY(32) not null,
	customer_zip_code_prefix int(5),
	customer_city VARCHAR(64),
	customer_state VARCHAR(2),
    primary key (customer_unique_id)
);
create table if not exists dados.olist_orders_dataset(
	order_id BINARY(32) not null,
    customer_id BINARY(32) not null,
    order_status VARCHAR(32),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    primary key (order_id),
    foreign key (customer_id) 
		references olist_customers_dataset(customer_unique_id)
);
create table if not exists dados.olist_order_payments_dataset(
    payment_id INT auto_increment,
    order_id BINARY(32) not null,
    payment_sequential INT(1) not null,
    payment_type VARCHAR(16) not null,
    payment_installments INT(2) not null,
    payment_value decimal(15,2) not null,
    primary key (payment_id),
    foreign key (order_id) 
		references olist_orders_dataset(order_id)
);
create table if not exists dados.olist_order_reviews_dataset(
	review_id BINARY(32) not null,
    order_id BINARY(32) not null,
    review_score INT(1),
    review_comment_title VARCHAR(256),
    review_comment_message VARCHAR(256),
    review_creation_date DATETIME,
    review_answer_timestamp TIMESTAMP,
    primary key (review_id),
    foreign key (order_id) 
		references olist_orders_dataset(order_id)
);
create table if not exists dados.olist_products_dataset(
	product_id BINARY(32) not null,
	product_category_name VARCHAR(100),
	product_name_lenght INT(8),
	product_description_lenght INT(8),
	product_photos_qty int(8),
	product_weight_g int(8),
	product_length_cm int(8),
	product_height_cm int(8),
	product_width_cm int(8),
    primary key (product_id),
    foreign key (product_category_name) 
		references product_category_name_translation(product_category_name)
);
create table if not exists dados.olist_sellers_dataset(
	seller_id BINARY(32) not null,
	seller_zip_code_prefix int(5),
	seller_city VARCHAR(64),
	seller_state VARCHAR(2),
    primary key (seller_id)
);
create table if not exists dados.olist_order_items_dataset(
	order_id BINARY(32),
	order_item_id INT(8),
	product_id BINARY(32),
	seller_id BINARY(32),
	shipping_limit_date TIMESTAMP,
	price DECIMAL(15,2),
	freight_value DECIMAL(15,2),
    primary key (order_id,order_item_id),
    foreign key(order_id) 
		references olist_orders_dataset(order_id),
    foreign key (seller_id) 
		references olist_sellers_dataset(seller_id),
    foreign key (product_id) 
		references olist_products_dataset(product_id)
);
