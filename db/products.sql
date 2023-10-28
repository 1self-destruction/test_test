CREATE TABLE products (
    id serial PRIMARY KEY,
    name text NOT NULL CHECK (length(name) <= 32),
    price integer CHECK (price >= 0 AND price <= 999999),
    description text CHECK (length(description) <= 100),
    sizes text[],
    tags text[]
);

CREATE TABLE orders (
    id serial PRIMARY KEY,
    user_id integer NOT NULL,
    product_ids integer[],
    status text
);

CREATE TABLE likes (
    product_id serial PRIMARY KEY,
    like_count integer DEFAULT 0
);

CREATE OR REPLACE FUNCTION add_remove_product_to_likes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO likes (product_id, like_count) VALUES (NEW.id, 0);
    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM likes WHERE product_id = OLD.id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_added_removed_to_likes
AFTER INSERT OR DELETE
ON products
FOR EACH ROW
EXECUTE FUNCTION add_remove_product_to_likes();