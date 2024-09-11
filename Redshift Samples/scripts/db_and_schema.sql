create database sap_fabric;

--Staging Schema's
create schema if not exists stg_p2p;
create schema if not exists stg_r2r;
create schema if not exists stg_otc;
create schema if not exists stg_md;

--Data Mart Schema's
create schema if not exists dm_p2p;
create schema if not exists dm_r2r;
create schema if not exists dm_otc;
create schema if not exists dm_md;