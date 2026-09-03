-- RHD-LifeServer extension schema
-- Designed to sit alongside the upstream Altis Life database.
-- Review your framework DB connector before applying in production.

CREATE TABLE IF NOT EXISTS rhd_economy_prices (
    item_class VARCHAR(64) NOT NULL PRIMARY KEY,
    base_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    current_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    demand_index DECIMAL(8,4) NOT NULL DEFAULT 1.0000,
    supply_index DECIMAL(8,4) NOT NULL DEFAULT 1.0000,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rhd_businesses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    owner_uid VARCHAR(64) NOT NULL,
    business_type VARCHAR(64) NOT NULL,
    business_name VARCHAR(128) NOT NULL,
    cash DECIMAL(14,2) NOT NULL DEFAULT 0,
    reputation INT NOT NULL DEFAULT 0,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_rhd_business_owner (owner_uid)
);

CREATE TABLE IF NOT EXISTS rhd_contracts (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    issuer_uid VARCHAR(64) NOT NULL,
    accepted_uid VARCHAR(64) NULL,
    contract_type VARCHAR(64) NOT NULL,
    reward DECIMAL(14,2) NOT NULL DEFAULT 0,
    status VARCHAR(24) NOT NULL DEFAULT 'open',
    payload_json JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL DEFAULT NULL,
    INDEX idx_rhd_contract_status (status),
    INDEX idx_rhd_contract_issuer (issuer_uid),
    INDEX idx_rhd_contract_acceptor (accepted_uid)
);

CREATE TABLE IF NOT EXISTS rhd_vehicle_services (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    owner_uid VARCHAR(64) NOT NULL,
    vehicle_key VARCHAR(128) NOT NULL,
    service_type VARCHAR(32) NOT NULL,
    service_level INT NOT NULL DEFAULT 0,
    last_service TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_rhd_vehicle_service (owner_uid, vehicle_key, service_type)
);
