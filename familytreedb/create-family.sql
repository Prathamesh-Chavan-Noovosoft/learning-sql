CREATE TABLE family
(
        id        BIGSERIAL PRIMARY KEY,
        parent_id BIGINT REFERENCES family (id),
        name      VARCHAR(255)
);

CREATE TABLE member
(
        id        BIGSERIAL PRIMARY KEY,
        parent_id BIGINT REFERENCES family (id),
        name      VARCHAR(255)

)

CREATE TABLE relation (
        {parent_id,id}        BIGSERIAL PRIMARY KEY,
        name      VARCHAR(255)

)
