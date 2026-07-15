CREATE DATABASE ProcurementSpendAnalysis;
GO

USE ProcurementSpendAnalysis;
GO

CREATE TABLE dbo.Contracts_Clean (
    contract_transaction_unique_key        NVARCHAR(50),
    award_id_piid                          NVARCHAR(50),
    recipient_name                         NVARCHAR(150),
    awarding_agency_name                   NVARCHAR(50),
    awarding_sub_agency_name               NVARCHAR(50),
    product_or_service_code_description    NVARCHAR(150),
    naics_description                      NVARCHAR(150),
    action_date                            DATE,
    federal_action_obligation              FLOAT,
    total_dollars_obligated                FLOAT,
    extent_competed                        NVARCHAR(100),
    type_of_contract_pricing               NVARCHAR(50),
    award_type                             NVARCHAR(50)
);
GO
