-- RHD-LifeServer extension schema
-- Designed to sit alongside the upstream Altis Life database.
-- Requires the upstream Framework extDB3/DB_fnc_asyncCall adapter.

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

CREATE TABLE IF NOT EXISTS rhd_business_accounts (
    business_key VARCHAR(96) NOT NULL PRIMARY KEY,
    owner_uid VARCHAR(32) NOT NULL,
    business_name VARCHAR(64) NOT NULL,
    balance DECIMAL(14,2) NOT NULL DEFAULT 0,
    active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_rhd_business_account_owner (owner_uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS rhd_business_transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    business_key VARCHAR(96) NOT NULL,
    owner_uid VARCHAR(32) NOT NULL,
    transaction_mode VARCHAR(16) NOT NULL,
    amount DECIMAL(14,2) NOT NULL,
    balance_before DECIMAL(14,2) NOT NULL,
    balance_after DECIMAL(14,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_rhd_business_tx_business (business_key),
    INDEX idx_rhd_business_tx_owner (owner_uid),
    INDEX idx_rhd_business_tx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE IF NOT EXISTS rhd_financial_transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    uid VARCHAR(32) NOT NULL,
    transaction_mode VARCHAR(16) NOT NULL,
    account_type VARCHAR(8) NOT NULL,
    amount DECIMAL(14,2) NOT NULL,
    balance_before DECIMAL(14,2) NOT NULL,
    balance_after DECIMAL(14,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_rhd_fin_uid (uid),
    INDEX idx_rhd_fin_created (created_at)
);

CREATE TABLE IF NOT EXISTS rhd_state (
    state_key VARCHAR(64) NOT NULL PRIMARY KEY,
    payload LONGTEXT NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
