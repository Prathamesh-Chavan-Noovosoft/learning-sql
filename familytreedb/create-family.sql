CREATE TABLE family
(
        id        BIGSERIAL PRIMARY KEY,
        parent_id BIGINT REFERENCES family (id),
        name      VARCHAR(255)
)
