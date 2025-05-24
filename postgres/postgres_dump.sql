--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17
-- Dumped by pg_dump version 14.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO root;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO root;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO root;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO root;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO root;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO root;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO root;

--
-- Name: client; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO root;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO root;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO root;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO root;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO root;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO root;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO root;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO root;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO root;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO root;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO root;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO root;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO root;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO root;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO root;

--
-- Name: component; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO root;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO root;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO root;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO root;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO root;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO root;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO root;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO root;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO root;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO root;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO root;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO root;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO root;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO root;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO root;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO root;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO root;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO root;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO root;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO root;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO root;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO root;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO root;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO root;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO root;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO root;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO root;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO root;

--
-- Name: org; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.org OWNER TO root;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO root;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO root;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO root;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO root;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO root;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO root;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO root;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO root;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO root;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO root;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO root;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO root;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO root;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO root;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO root;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO root;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO root;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO root;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO root;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO root;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO root;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO root;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO root;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO root;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO root;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO root;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO root;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO root;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO root;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO root;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO root;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO root;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO root;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO root;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO root;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO root;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO root;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO root;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO root;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO root;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO root;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO root;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO root;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
36413538-476d-4ab6-8001-0ba3cad59ed2	\N	auth-cookie	54f3ea06-8843-40e5-b3eb-be7e36221acb	e78b81e3-1014-4513-90d1-cd76de9d0f73	2	10	f	\N	\N
d97b6696-fcec-4fd2-baad-f9fa553876f3	\N	auth-spnego	54f3ea06-8843-40e5-b3eb-be7e36221acb	e78b81e3-1014-4513-90d1-cd76de9d0f73	3	20	f	\N	\N
fcba7341-d6bd-429a-a0ed-e1f151186680	\N	identity-provider-redirector	54f3ea06-8843-40e5-b3eb-be7e36221acb	e78b81e3-1014-4513-90d1-cd76de9d0f73	2	25	f	\N	\N
cc3282f8-aca7-47ac-aa12-c72f1174b54c	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	e78b81e3-1014-4513-90d1-cd76de9d0f73	2	30	t	83972df2-3e02-4a2b-b5cf-5b282cad8123	\N
18f6bfc6-d0a5-4bbd-8e9e-049114e64005	\N	auth-username-password-form	54f3ea06-8843-40e5-b3eb-be7e36221acb	83972df2-3e02-4a2b-b5cf-5b282cad8123	0	10	f	\N	\N
1cb6c298-b141-4796-8a66-21028720b6ad	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	83972df2-3e02-4a2b-b5cf-5b282cad8123	1	20	t	1d9620ea-9f72-4d79-88a8-881fe2006c7d	\N
7441b92b-40a4-4fc6-95fb-64bcff0cf9bc	\N	conditional-user-configured	54f3ea06-8843-40e5-b3eb-be7e36221acb	1d9620ea-9f72-4d79-88a8-881fe2006c7d	0	10	f	\N	\N
8797f1df-fb09-4df4-b987-fb8c5b73fd9a	\N	auth-otp-form	54f3ea06-8843-40e5-b3eb-be7e36221acb	1d9620ea-9f72-4d79-88a8-881fe2006c7d	0	20	f	\N	\N
e0283925-0b9f-4cd7-8c83-a1a57dea2765	\N	direct-grant-validate-username	54f3ea06-8843-40e5-b3eb-be7e36221acb	c299bd38-a263-4ee7-b5b2-48ae6dad3a94	0	10	f	\N	\N
8683fb72-6f52-47e4-879f-fc438498ebcb	\N	direct-grant-validate-password	54f3ea06-8843-40e5-b3eb-be7e36221acb	c299bd38-a263-4ee7-b5b2-48ae6dad3a94	0	20	f	\N	\N
fd92034f-bfb2-4ced-bf5c-7804706388ed	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	c299bd38-a263-4ee7-b5b2-48ae6dad3a94	1	30	t	29e1da9a-e2dc-43fd-93dd-bc1a64029bcd	\N
128c1251-38a4-49dd-a3c0-959bf1503f17	\N	conditional-user-configured	54f3ea06-8843-40e5-b3eb-be7e36221acb	29e1da9a-e2dc-43fd-93dd-bc1a64029bcd	0	10	f	\N	\N
50c3eec1-2afa-4322-89e2-8be24df9fa63	\N	direct-grant-validate-otp	54f3ea06-8843-40e5-b3eb-be7e36221acb	29e1da9a-e2dc-43fd-93dd-bc1a64029bcd	0	20	f	\N	\N
4797b6a9-4ab0-4e45-a799-cb348c5f7e81	\N	registration-page-form	54f3ea06-8843-40e5-b3eb-be7e36221acb	7aa347db-c872-4db6-929e-fea17d85a200	0	10	t	b635ef45-b025-462d-b04f-edaf70050845	\N
704c2ba3-5e0e-43df-b529-51fd12ab75c7	\N	registration-user-creation	54f3ea06-8843-40e5-b3eb-be7e36221acb	b635ef45-b025-462d-b04f-edaf70050845	0	20	f	\N	\N
4a3de304-d5b0-4ca5-866e-474a4e958bb3	\N	registration-password-action	54f3ea06-8843-40e5-b3eb-be7e36221acb	b635ef45-b025-462d-b04f-edaf70050845	0	50	f	\N	\N
4b585b97-e3ca-4d4d-9a9c-d7c6a8420cf3	\N	registration-recaptcha-action	54f3ea06-8843-40e5-b3eb-be7e36221acb	b635ef45-b025-462d-b04f-edaf70050845	3	60	f	\N	\N
13a715c9-f1a0-4cf3-a185-9f1f19b60b02	\N	registration-terms-and-conditions	54f3ea06-8843-40e5-b3eb-be7e36221acb	b635ef45-b025-462d-b04f-edaf70050845	3	70	f	\N	\N
e912bf5a-968e-4fc4-99fb-0037ec321948	\N	reset-credentials-choose-user	54f3ea06-8843-40e5-b3eb-be7e36221acb	0fdbd9a8-3063-4a5b-92e7-22cf2a72d938	0	10	f	\N	\N
cfd124ce-e100-4733-9b9b-8cf5637b35e7	\N	reset-credential-email	54f3ea06-8843-40e5-b3eb-be7e36221acb	0fdbd9a8-3063-4a5b-92e7-22cf2a72d938	0	20	f	\N	\N
d847a463-fc0b-4398-a4fd-f3500abca345	\N	reset-password	54f3ea06-8843-40e5-b3eb-be7e36221acb	0fdbd9a8-3063-4a5b-92e7-22cf2a72d938	0	30	f	\N	\N
3ec187c7-86be-42d8-933b-340bf3eef9e0	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	0fdbd9a8-3063-4a5b-92e7-22cf2a72d938	1	40	t	44b3b742-247a-4188-8033-afb80dc04049	\N
063b0122-95c3-474d-a0a1-02f64a3b75ed	\N	conditional-user-configured	54f3ea06-8843-40e5-b3eb-be7e36221acb	44b3b742-247a-4188-8033-afb80dc04049	0	10	f	\N	\N
a39c0bf5-a3e8-49ea-9d47-727cd7e49f24	\N	reset-otp	54f3ea06-8843-40e5-b3eb-be7e36221acb	44b3b742-247a-4188-8033-afb80dc04049	0	20	f	\N	\N
b13db46f-dd77-4b56-8dee-463f9946f2ac	\N	client-secret	54f3ea06-8843-40e5-b3eb-be7e36221acb	46e861c8-c21a-4415-9bc0-193826ebb153	2	10	f	\N	\N
89a7be1c-cbcd-4032-a54b-892979f78c1f	\N	client-jwt	54f3ea06-8843-40e5-b3eb-be7e36221acb	46e861c8-c21a-4415-9bc0-193826ebb153	2	20	f	\N	\N
f06e4833-a29e-4a3e-b335-e45ebb012452	\N	client-secret-jwt	54f3ea06-8843-40e5-b3eb-be7e36221acb	46e861c8-c21a-4415-9bc0-193826ebb153	2	30	f	\N	\N
09b1414c-82c2-4fd3-908b-9aa370f6f6d9	\N	client-x509	54f3ea06-8843-40e5-b3eb-be7e36221acb	46e861c8-c21a-4415-9bc0-193826ebb153	2	40	f	\N	\N
0abf44ba-b620-4b6d-910b-6da9d6dd851c	\N	idp-review-profile	54f3ea06-8843-40e5-b3eb-be7e36221acb	f6dcf37d-fb5c-4e0c-94ca-68c9f85bcd88	0	10	f	\N	d7cdfbb6-975e-46ef-9c89-b3a0e5dd8569
5228da91-9ff7-42c4-9fd4-5ea4d4cc09ff	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	f6dcf37d-fb5c-4e0c-94ca-68c9f85bcd88	0	20	t	5985e4e3-d92f-49ed-abb5-0dc7c851eae6	\N
d77c96b9-1533-4d84-9285-b8dca972f670	\N	idp-create-user-if-unique	54f3ea06-8843-40e5-b3eb-be7e36221acb	5985e4e3-d92f-49ed-abb5-0dc7c851eae6	2	10	f	\N	9246e73c-6f97-439b-b8cf-72a3aa3124cf
30998049-13af-48a2-9961-3ab9b4e96333	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	5985e4e3-d92f-49ed-abb5-0dc7c851eae6	2	20	t	583f330b-c31c-4731-a387-9be9a3bb356a	\N
361b2181-be14-4d4b-abac-7ee000c023af	\N	idp-confirm-link	54f3ea06-8843-40e5-b3eb-be7e36221acb	583f330b-c31c-4731-a387-9be9a3bb356a	0	10	f	\N	\N
b63629c6-6ec5-4bb3-9251-4b8949e363e6	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	583f330b-c31c-4731-a387-9be9a3bb356a	0	20	t	2a62b428-b959-4328-81eb-9f180578ae1c	\N
474d9c8f-e859-4313-b840-29f568b3304d	\N	idp-email-verification	54f3ea06-8843-40e5-b3eb-be7e36221acb	2a62b428-b959-4328-81eb-9f180578ae1c	2	10	f	\N	\N
04635cdd-b568-409c-86de-9dca3cc8a44f	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	2a62b428-b959-4328-81eb-9f180578ae1c	2	20	t	ebd4fd9b-6321-4e4b-9289-84e494a99a6b	\N
917af619-8164-4bc0-94c7-1116da74bbfa	\N	idp-username-password-form	54f3ea06-8843-40e5-b3eb-be7e36221acb	ebd4fd9b-6321-4e4b-9289-84e494a99a6b	0	10	f	\N	\N
35a356fa-7c87-4230-a061-f7b13a67ad98	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	ebd4fd9b-6321-4e4b-9289-84e494a99a6b	1	20	t	5b0b69b7-3ca2-4b5b-8729-28be1c5818e7	\N
280ed931-29cd-4942-bebf-1fb859016359	\N	conditional-user-configured	54f3ea06-8843-40e5-b3eb-be7e36221acb	5b0b69b7-3ca2-4b5b-8729-28be1c5818e7	0	10	f	\N	\N
44f4a0a4-57be-4a94-b711-5c7fc04ce97a	\N	auth-otp-form	54f3ea06-8843-40e5-b3eb-be7e36221acb	5b0b69b7-3ca2-4b5b-8729-28be1c5818e7	0	20	f	\N	\N
00619a48-6f2e-49e6-bf5d-dd58213a440f	\N	http-basic-authenticator	54f3ea06-8843-40e5-b3eb-be7e36221acb	5644edf1-3982-463f-85ab-7f3d14d6fc9d	0	10	f	\N	\N
78cfc833-3168-47b6-b448-fd45400f19db	\N	docker-http-basic-authenticator	54f3ea06-8843-40e5-b3eb-be7e36221acb	29218bdc-aab6-49cd-8853-05f87d348070	0	10	f	\N	\N
172c3430-e839-4bfe-a7be-c02e4cbd458b	\N	auth-cookie	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	14f9cc2f-96d3-4bbb-a6fc-d800afed3bc8	2	10	f	\N	\N
523599b1-2fd9-496a-bb97-02a17b8f2ea8	\N	auth-spnego	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	14f9cc2f-96d3-4bbb-a6fc-d800afed3bc8	3	20	f	\N	\N
d35d6bd9-64f4-4655-86de-94ac0c1e149a	\N	identity-provider-redirector	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	14f9cc2f-96d3-4bbb-a6fc-d800afed3bc8	2	25	f	\N	\N
20233c17-ad38-4650-b141-6abe68a2a4c0	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	14f9cc2f-96d3-4bbb-a6fc-d800afed3bc8	2	30	t	6e2f2ca6-3041-4bae-9345-be9e8dacd162	\N
9ca43065-8f6f-4bad-999f-4910777d964e	\N	auth-username-password-form	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	6e2f2ca6-3041-4bae-9345-be9e8dacd162	0	10	f	\N	\N
3c1c4e74-6f5f-4767-bf50-498e2ccaf87b	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	6e2f2ca6-3041-4bae-9345-be9e8dacd162	1	20	t	29f7334e-3d2d-4d3d-bcfa-50ac0d5e7046	\N
7ce90fb3-4bb9-4915-9998-3de3da45cc26	\N	conditional-user-configured	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	29f7334e-3d2d-4d3d-bcfa-50ac0d5e7046	0	10	f	\N	\N
6b2d266b-3c93-44ac-8432-2cc1ff784a66	\N	auth-otp-form	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	29f7334e-3d2d-4d3d-bcfa-50ac0d5e7046	0	20	f	\N	\N
9f400b4a-46ca-474a-88ed-d585c402e73d	\N	direct-grant-validate-username	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	1ffdebbb-ce1c-4e34-b061-52621653a523	0	10	f	\N	\N
b3d06989-a254-40d1-b63a-4bddafb5e359	\N	direct-grant-validate-password	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	1ffdebbb-ce1c-4e34-b061-52621653a523	0	20	f	\N	\N
10b769fe-576b-4640-9ab3-5cc5948c289d	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	1ffdebbb-ce1c-4e34-b061-52621653a523	1	30	t	02a5d4a2-2216-4bf7-a491-8d18081519bd	\N
4c311ff6-e6e4-457d-ae0a-81417053a893	\N	conditional-user-configured	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	02a5d4a2-2216-4bf7-a491-8d18081519bd	0	10	f	\N	\N
c8712f96-b923-44be-a8fd-159b6a8f4e4d	\N	direct-grant-validate-otp	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	02a5d4a2-2216-4bf7-a491-8d18081519bd	0	20	f	\N	\N
9d10f325-e594-43e5-a5dd-3a8feb5548fa	\N	registration-page-form	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9e645db6-7b14-418f-909c-5ef9889f6d99	0	10	t	cb11428a-cf06-4af4-a570-5197446ce560	\N
e18ef4aa-d835-4db2-b7fa-fc8823a049af	\N	registration-user-creation	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	cb11428a-cf06-4af4-a570-5197446ce560	0	20	f	\N	\N
c66b8718-b4e3-49e3-9be9-e5d552b95b31	\N	registration-password-action	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	cb11428a-cf06-4af4-a570-5197446ce560	0	50	f	\N	\N
d9229a62-5feb-4b74-8f6c-a5e9bd177f56	\N	registration-recaptcha-action	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	cb11428a-cf06-4af4-a570-5197446ce560	3	60	f	\N	\N
480e0598-8e12-4204-8c47-8b32f79f0d3a	\N	registration-terms-and-conditions	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	cb11428a-cf06-4af4-a570-5197446ce560	3	70	f	\N	\N
7526b498-6629-41b9-ab65-f244da26d414	\N	reset-credentials-choose-user	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	dfec3aaa-6640-48a5-9847-1b1367597ed1	0	10	f	\N	\N
5601caff-e302-4555-8fb3-3acff98c8acd	\N	reset-credential-email	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	dfec3aaa-6640-48a5-9847-1b1367597ed1	0	20	f	\N	\N
be4fd4e5-26b4-409f-a14c-c41b3a47e8db	\N	reset-password	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	dfec3aaa-6640-48a5-9847-1b1367597ed1	0	30	f	\N	\N
d4c0995a-864b-472c-adcd-7ef01b2e9dfe	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	dfec3aaa-6640-48a5-9847-1b1367597ed1	1	40	t	f2cbe4be-6e34-4548-a9a7-53652bebd36c	\N
ba61908e-de41-47d2-8eeb-9d2fb89fbed4	\N	conditional-user-configured	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f2cbe4be-6e34-4548-a9a7-53652bebd36c	0	10	f	\N	\N
82f41d3b-e720-4917-bb23-100ba959b08a	\N	reset-otp	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f2cbe4be-6e34-4548-a9a7-53652bebd36c	0	20	f	\N	\N
abb830a6-01b9-4141-bbe5-36a923ca8495	\N	client-secret	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9fc7473d-e2f9-4c11-a44a-91fbaeb3d531	2	10	f	\N	\N
2c57c0dc-1653-48c8-95b5-e80ab4f263de	\N	client-jwt	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9fc7473d-e2f9-4c11-a44a-91fbaeb3d531	2	20	f	\N	\N
a704e8b5-ce72-4ddd-8278-0505fea2e035	\N	client-secret-jwt	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9fc7473d-e2f9-4c11-a44a-91fbaeb3d531	2	30	f	\N	\N
0c01502c-93b1-4952-9825-7cdf156fc2d5	\N	client-x509	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9fc7473d-e2f9-4c11-a44a-91fbaeb3d531	2	40	f	\N	\N
51418088-9504-484a-919f-288a70f7bc9c	\N	idp-review-profile	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	349f403b-1694-47f6-8d47-5a30da720a56	0	10	f	\N	13b40819-22d6-415e-89fe-423ebb7cbfd2
cfc1c62a-65c4-4c86-bdb7-7a3ca271e55c	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	349f403b-1694-47f6-8d47-5a30da720a56	0	20	t	f6ee9805-f540-442c-9225-637d15dfafcc	\N
dc97c535-e5cb-4099-8d2b-c02c7d298565	\N	idp-create-user-if-unique	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f6ee9805-f540-442c-9225-637d15dfafcc	2	10	f	\N	1a84088a-6468-4e00-a030-3a3dd441a6c0
3603a6a5-cafb-4d16-9545-5021511162a9	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f6ee9805-f540-442c-9225-637d15dfafcc	2	20	t	5ad10a32-7b49-4573-a505-4c8aa9aeb6dc	\N
c229c436-5a7f-4e2a-803e-4ad337cbc3ce	\N	idp-confirm-link	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	5ad10a32-7b49-4573-a505-4c8aa9aeb6dc	0	10	f	\N	\N
e938cff6-b6bf-4935-847e-bac00d48312b	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	5ad10a32-7b49-4573-a505-4c8aa9aeb6dc	0	20	t	910df0b4-3f5f-446e-96d2-ee0d61f4f4a5	\N
1732bd5c-cb44-40ff-934e-db8acea6c54a	\N	idp-email-verification	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	910df0b4-3f5f-446e-96d2-ee0d61f4f4a5	2	10	f	\N	\N
04a7f129-42a0-45ed-8564-efb522d04168	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	910df0b4-3f5f-446e-96d2-ee0d61f4f4a5	2	20	t	17c48bb7-f5b7-4b8b-b485-0eb9e3db5bc4	\N
ce136b2a-d56d-4f4e-8565-d3ca192e6245	\N	idp-username-password-form	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	17c48bb7-f5b7-4b8b-b485-0eb9e3db5bc4	0	10	f	\N	\N
17696712-8420-4098-a32f-9b2956700d2d	\N	\N	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	17c48bb7-f5b7-4b8b-b485-0eb9e3db5bc4	1	20	t	9fa6567a-ff6d-4322-93fc-72593a2bb516	\N
c4326818-3b5d-413f-ab24-7780af9b010d	\N	conditional-user-configured	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9fa6567a-ff6d-4322-93fc-72593a2bb516	0	10	f	\N	\N
2ca72008-a710-4b41-94e0-cc25127cd3ce	\N	auth-otp-form	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9fa6567a-ff6d-4322-93fc-72593a2bb516	0	20	f	\N	\N
750b36b5-a452-4c2a-a5ce-1bfa24f990e5	\N	http-basic-authenticator	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	5f2b1418-c42a-45e6-b0fd-88118a6b45c0	0	10	f	\N	\N
0e41fbf1-beac-42fd-ad14-fd035cb68866	\N	docker-http-basic-authenticator	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	c8929114-ff35-42d8-aa6b-d05bea2a4c32	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
e78b81e3-1014-4513-90d1-cd76de9d0f73	browser	browser based authentication	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
83972df2-3e02-4a2b-b5cf-5b282cad8123	forms	Username, password, otp and other auth forms.	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
1d9620ea-9f72-4d79-88a8-881fe2006c7d	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
c299bd38-a263-4ee7-b5b2-48ae6dad3a94	direct grant	OpenID Connect Resource Owner Grant	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
29e1da9a-e2dc-43fd-93dd-bc1a64029bcd	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
7aa347db-c872-4db6-929e-fea17d85a200	registration	registration flow	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
b635ef45-b025-462d-b04f-edaf70050845	registration form	registration form	54f3ea06-8843-40e5-b3eb-be7e36221acb	form-flow	f	t
0fdbd9a8-3063-4a5b-92e7-22cf2a72d938	reset credentials	Reset credentials for a user if they forgot their password or something	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
44b3b742-247a-4188-8033-afb80dc04049	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
46e861c8-c21a-4415-9bc0-193826ebb153	clients	Base authentication for clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	client-flow	t	t
f6dcf37d-fb5c-4e0c-94ca-68c9f85bcd88	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
5985e4e3-d92f-49ed-abb5-0dc7c851eae6	User creation or linking	Flow for the existing/non-existing user alternatives	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
583f330b-c31c-4731-a387-9be9a3bb356a	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
2a62b428-b959-4328-81eb-9f180578ae1c	Account verification options	Method with which to verity the existing account	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
ebd4fd9b-6321-4e4b-9289-84e494a99a6b	Verify Existing Account by Re-authentication	Reauthentication of existing account	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
5b0b69b7-3ca2-4b5b-8729-28be1c5818e7	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	f	t
5644edf1-3982-463f-85ab-7f3d14d6fc9d	saml ecp	SAML ECP Profile Authentication Flow	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
29218bdc-aab6-49cd-8853-05f87d348070	docker auth	Used by Docker clients to authenticate against the IDP	54f3ea06-8843-40e5-b3eb-be7e36221acb	basic-flow	t	t
14f9cc2f-96d3-4bbb-a6fc-d800afed3bc8	browser	browser based authentication	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
6e2f2ca6-3041-4bae-9345-be9e8dacd162	forms	Username, password, otp and other auth forms.	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
29f7334e-3d2d-4d3d-bcfa-50ac0d5e7046	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
1ffdebbb-ce1c-4e34-b061-52621653a523	direct grant	OpenID Connect Resource Owner Grant	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
02a5d4a2-2216-4bf7-a491-8d18081519bd	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
9e645db6-7b14-418f-909c-5ef9889f6d99	registration	registration flow	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
cb11428a-cf06-4af4-a570-5197446ce560	registration form	registration form	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	form-flow	f	t
dfec3aaa-6640-48a5-9847-1b1367597ed1	reset credentials	Reset credentials for a user if they forgot their password or something	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
f2cbe4be-6e34-4548-a9a7-53652bebd36c	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
9fc7473d-e2f9-4c11-a44a-91fbaeb3d531	clients	Base authentication for clients	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	client-flow	t	t
349f403b-1694-47f6-8d47-5a30da720a56	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
f6ee9805-f540-442c-9225-637d15dfafcc	User creation or linking	Flow for the existing/non-existing user alternatives	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
5ad10a32-7b49-4573-a505-4c8aa9aeb6dc	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
910df0b4-3f5f-446e-96d2-ee0d61f4f4a5	Account verification options	Method with which to verity the existing account	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
17c48bb7-f5b7-4b8b-b485-0eb9e3db5bc4	Verify Existing Account by Re-authentication	Reauthentication of existing account	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
9fa6567a-ff6d-4322-93fc-72593a2bb516	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	f	t
5f2b1418-c42a-45e6-b0fd-88118a6b45c0	saml ecp	SAML ECP Profile Authentication Flow	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
c8929114-ff35-42d8-aa6b-d05bea2a4c32	docker auth	Used by Docker clients to authenticate against the IDP	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
d7cdfbb6-975e-46ef-9c89-b3a0e5dd8569	review profile config	54f3ea06-8843-40e5-b3eb-be7e36221acb
9246e73c-6f97-439b-b8cf-72a3aa3124cf	create unique user config	54f3ea06-8843-40e5-b3eb-be7e36221acb
13b40819-22d6-415e-89fe-423ebb7cbfd2	review profile config	abd99bcc-2d33-4252-853a-bd2e74d3a9a5
1a84088a-6468-4e00-a030-3a3dd441a6c0	create unique user config	abd99bcc-2d33-4252-853a-bd2e74d3a9a5
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
9246e73c-6f97-439b-b8cf-72a3aa3124cf	false	require.password.update.after.registration
d7cdfbb6-975e-46ef-9c89-b3a0e5dd8569	missing	update.profile.on.first.login
13b40819-22d6-415e-89fe-423ebb7cbfd2	missing	update.profile.on.first.login
1a84088a-6468-4e00-a030-3a3dd441a6c0	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
caf4db36-734a-456b-89dd-d093baa1450b	t	f	master-realm	0	f	\N	\N	t	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
fe643097-576a-4604-bf5f-de842a33cc31	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
23461f57-66b4-4ec3-bb77-9a8163c79075	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
a6fad9c7-8475-49b0-91c9-be60736ac6ec	t	f	broker	0	f	\N	\N	t	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
a145efeb-53a4-4adb-9420-cc3a6d59354d	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
7e047130-dea0-4b77-bd00-6746b934b94f	t	f	admin-cli	0	t	\N	\N	f	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
6eec7586-daea-481d-b5b7-f9a206131fc5	t	f	external-realm	0	f	\N	\N	t	\N	f	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	0	f	f	external Realm	f	client-secret	\N	\N	\N	t	f	f	f
f89bc995-b3f9-44e1-96b1-c9725e42f424	t	f	realm-management	0	f	\N	\N	t	\N	f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	f	account	0	t	\N	/realms/external/account/	f	\N	f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
237dc447-55be-4469-bbcd-39dd7f9f4d17	t	f	account-console	0	t	\N	/realms/external/account/	f	\N	f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
0728eec4-be95-424c-bcc2-af168326f808	t	f	broker	0	f	\N	\N	t	\N	f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
7c86823f-cc1a-43d0-ae29-6e82a14c1256	t	f	security-admin-console	0	t	\N	/admin/external/console/	f	\N	f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
bb000d67-c081-4eee-9b15-4680a04065e0	t	f	admin-cli	0	t	\N	\N	f	\N	f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	t	t	external-client	0	t	\N		f		f	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	openid-connect	-1	t	f		f	client-secret			\N	t	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
fe643097-576a-4604-bf5f-de842a33cc31	post.logout.redirect.uris	+
23461f57-66b4-4ec3-bb77-9a8163c79075	post.logout.redirect.uris	+
23461f57-66b4-4ec3-bb77-9a8163c79075	pkce.code.challenge.method	S256
a145efeb-53a4-4adb-9420-cc3a6d59354d	post.logout.redirect.uris	+
a145efeb-53a4-4adb-9420-cc3a6d59354d	pkce.code.challenge.method	S256
132dc426-0436-4e8b-8ea1-6e64ff9432d0	post.logout.redirect.uris	+
237dc447-55be-4469-bbcd-39dd7f9f4d17	post.logout.redirect.uris	+
237dc447-55be-4469-bbcd-39dd7f9f4d17	pkce.code.challenge.method	S256
7c86823f-cc1a-43d0-ae29-6e82a14c1256	post.logout.redirect.uris	+
7c86823f-cc1a-43d0-ae29-6e82a14c1256	pkce.code.challenge.method	S256
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	oauth2.device.authorization.grant.enabled	false
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	oidc.ciba.grant.enabled	false
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	backchannel.logout.session.required	true
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	backchannel.logout.revoke.offline.tokens	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
9a724b01-3203-4cce-bb10-3a9906087bcd	offline_access	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect built-in scope: offline_access	openid-connect
6294c8fa-95e5-42f5-8b45-5a196344e1fa	role_list	54f3ea06-8843-40e5-b3eb-be7e36221acb	SAML role list	saml
b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	profile	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect built-in scope: profile	openid-connect
98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	email	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect built-in scope: email	openid-connect
b9371a26-352d-4467-9d38-01aa81dc29a2	address	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect built-in scope: address	openid-connect
ea7e17a4-b6ac-478f-b7a1-f1261629fafb	phone	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect built-in scope: phone	openid-connect
06112d62-6860-4127-b75b-62969292df52	roles	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect scope for add user roles to the access token	openid-connect
4aa77aa5-671c-4088-97cc-851999012be7	web-origins	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect scope for add allowed web origins to the access token	openid-connect
9aff924a-e12d-434c-95ca-9c8b4787d1ff	microprofile-jwt	54f3ea06-8843-40e5-b3eb-be7e36221acb	Microprofile - JWT built-in scope	openid-connect
520dab19-2b7f-4aeb-b74e-df9953057b57	acr	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	basic	54f3ea06-8843-40e5-b3eb-be7e36221acb	OpenID Connect scope for add all basic claims to the token	openid-connect
98980e62-59c7-4263-8eaf-d247f31fa096	offline_access	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect built-in scope: offline_access	openid-connect
e7bce410-4612-45ed-8bc8-71f8b5ea5ba1	role_list	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	SAML role list	saml
0b39130e-8344-443a-a056-6847466aeb84	profile	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect built-in scope: profile	openid-connect
004c1da0-580d-4c27-bc3b-ccaac887836b	email	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect built-in scope: email	openid-connect
fdc55342-8c8f-443b-82bd-b247fef073cf	address	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect built-in scope: address	openid-connect
90649879-c0b5-43db-895e-704a0be0026b	phone	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect built-in scope: phone	openid-connect
09b3d3f2-3043-4971-b195-a289348e772b	roles	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect scope for add user roles to the access token	openid-connect
600aaf34-ed49-403f-a5b5-11af5f66006f	web-origins	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect scope for add allowed web origins to the access token	openid-connect
db6feb21-f3a2-45c9-b8d1-091b83900c6c	microprofile-jwt	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	Microprofile - JWT built-in scope	openid-connect
37523f14-c9c0-40e2-9849-6e43373267d9	acr	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
9cfc1f19-81ce-4f04-8159-8c468440ca23	basic	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	OpenID Connect scope for add all basic claims to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
9a724b01-3203-4cce-bb10-3a9906087bcd	true	display.on.consent.screen
9a724b01-3203-4cce-bb10-3a9906087bcd	${offlineAccessScopeConsentText}	consent.screen.text
6294c8fa-95e5-42f5-8b45-5a196344e1fa	true	display.on.consent.screen
6294c8fa-95e5-42f5-8b45-5a196344e1fa	${samlRoleListScopeConsentText}	consent.screen.text
b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	true	display.on.consent.screen
b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	${profileScopeConsentText}	consent.screen.text
b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	true	include.in.token.scope
98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	true	display.on.consent.screen
98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	${emailScopeConsentText}	consent.screen.text
98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	true	include.in.token.scope
b9371a26-352d-4467-9d38-01aa81dc29a2	true	display.on.consent.screen
b9371a26-352d-4467-9d38-01aa81dc29a2	${addressScopeConsentText}	consent.screen.text
b9371a26-352d-4467-9d38-01aa81dc29a2	true	include.in.token.scope
ea7e17a4-b6ac-478f-b7a1-f1261629fafb	true	display.on.consent.screen
ea7e17a4-b6ac-478f-b7a1-f1261629fafb	${phoneScopeConsentText}	consent.screen.text
ea7e17a4-b6ac-478f-b7a1-f1261629fafb	true	include.in.token.scope
06112d62-6860-4127-b75b-62969292df52	true	display.on.consent.screen
06112d62-6860-4127-b75b-62969292df52	${rolesScopeConsentText}	consent.screen.text
06112d62-6860-4127-b75b-62969292df52	false	include.in.token.scope
4aa77aa5-671c-4088-97cc-851999012be7	false	display.on.consent.screen
4aa77aa5-671c-4088-97cc-851999012be7		consent.screen.text
4aa77aa5-671c-4088-97cc-851999012be7	false	include.in.token.scope
9aff924a-e12d-434c-95ca-9c8b4787d1ff	false	display.on.consent.screen
9aff924a-e12d-434c-95ca-9c8b4787d1ff	true	include.in.token.scope
520dab19-2b7f-4aeb-b74e-df9953057b57	false	display.on.consent.screen
520dab19-2b7f-4aeb-b74e-df9953057b57	false	include.in.token.scope
0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	false	display.on.consent.screen
0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	false	include.in.token.scope
98980e62-59c7-4263-8eaf-d247f31fa096	true	display.on.consent.screen
98980e62-59c7-4263-8eaf-d247f31fa096	${offlineAccessScopeConsentText}	consent.screen.text
e7bce410-4612-45ed-8bc8-71f8b5ea5ba1	true	display.on.consent.screen
e7bce410-4612-45ed-8bc8-71f8b5ea5ba1	${samlRoleListScopeConsentText}	consent.screen.text
0b39130e-8344-443a-a056-6847466aeb84	true	display.on.consent.screen
0b39130e-8344-443a-a056-6847466aeb84	${profileScopeConsentText}	consent.screen.text
0b39130e-8344-443a-a056-6847466aeb84	true	include.in.token.scope
004c1da0-580d-4c27-bc3b-ccaac887836b	true	display.on.consent.screen
004c1da0-580d-4c27-bc3b-ccaac887836b	${emailScopeConsentText}	consent.screen.text
004c1da0-580d-4c27-bc3b-ccaac887836b	true	include.in.token.scope
fdc55342-8c8f-443b-82bd-b247fef073cf	true	display.on.consent.screen
fdc55342-8c8f-443b-82bd-b247fef073cf	${addressScopeConsentText}	consent.screen.text
fdc55342-8c8f-443b-82bd-b247fef073cf	true	include.in.token.scope
90649879-c0b5-43db-895e-704a0be0026b	true	display.on.consent.screen
90649879-c0b5-43db-895e-704a0be0026b	${phoneScopeConsentText}	consent.screen.text
90649879-c0b5-43db-895e-704a0be0026b	true	include.in.token.scope
09b3d3f2-3043-4971-b195-a289348e772b	true	display.on.consent.screen
09b3d3f2-3043-4971-b195-a289348e772b	${rolesScopeConsentText}	consent.screen.text
09b3d3f2-3043-4971-b195-a289348e772b	false	include.in.token.scope
600aaf34-ed49-403f-a5b5-11af5f66006f	false	display.on.consent.screen
600aaf34-ed49-403f-a5b5-11af5f66006f		consent.screen.text
600aaf34-ed49-403f-a5b5-11af5f66006f	false	include.in.token.scope
db6feb21-f3a2-45c9-b8d1-091b83900c6c	false	display.on.consent.screen
db6feb21-f3a2-45c9-b8d1-091b83900c6c	true	include.in.token.scope
37523f14-c9c0-40e2-9849-6e43373267d9	false	display.on.consent.screen
37523f14-c9c0-40e2-9849-6e43373267d9	false	include.in.token.scope
9cfc1f19-81ce-4f04-8159-8c468440ca23	false	display.on.consent.screen
9cfc1f19-81ce-4f04-8159-8c468440ca23	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
fe643097-576a-4604-bf5f-de842a33cc31	520dab19-2b7f-4aeb-b74e-df9953057b57	t
fe643097-576a-4604-bf5f-de842a33cc31	4aa77aa5-671c-4088-97cc-851999012be7	t
fe643097-576a-4604-bf5f-de842a33cc31	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
fe643097-576a-4604-bf5f-de842a33cc31	06112d62-6860-4127-b75b-62969292df52	t
fe643097-576a-4604-bf5f-de842a33cc31	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
fe643097-576a-4604-bf5f-de842a33cc31	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
fe643097-576a-4604-bf5f-de842a33cc31	9a724b01-3203-4cce-bb10-3a9906087bcd	f
fe643097-576a-4604-bf5f-de842a33cc31	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
fe643097-576a-4604-bf5f-de842a33cc31	b9371a26-352d-4467-9d38-01aa81dc29a2	f
fe643097-576a-4604-bf5f-de842a33cc31	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
23461f57-66b4-4ec3-bb77-9a8163c79075	520dab19-2b7f-4aeb-b74e-df9953057b57	t
23461f57-66b4-4ec3-bb77-9a8163c79075	4aa77aa5-671c-4088-97cc-851999012be7	t
23461f57-66b4-4ec3-bb77-9a8163c79075	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
23461f57-66b4-4ec3-bb77-9a8163c79075	06112d62-6860-4127-b75b-62969292df52	t
23461f57-66b4-4ec3-bb77-9a8163c79075	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
23461f57-66b4-4ec3-bb77-9a8163c79075	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
23461f57-66b4-4ec3-bb77-9a8163c79075	9a724b01-3203-4cce-bb10-3a9906087bcd	f
23461f57-66b4-4ec3-bb77-9a8163c79075	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
23461f57-66b4-4ec3-bb77-9a8163c79075	b9371a26-352d-4467-9d38-01aa81dc29a2	f
23461f57-66b4-4ec3-bb77-9a8163c79075	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
7e047130-dea0-4b77-bd00-6746b934b94f	520dab19-2b7f-4aeb-b74e-df9953057b57	t
7e047130-dea0-4b77-bd00-6746b934b94f	4aa77aa5-671c-4088-97cc-851999012be7	t
7e047130-dea0-4b77-bd00-6746b934b94f	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
7e047130-dea0-4b77-bd00-6746b934b94f	06112d62-6860-4127-b75b-62969292df52	t
7e047130-dea0-4b77-bd00-6746b934b94f	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
7e047130-dea0-4b77-bd00-6746b934b94f	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
7e047130-dea0-4b77-bd00-6746b934b94f	9a724b01-3203-4cce-bb10-3a9906087bcd	f
7e047130-dea0-4b77-bd00-6746b934b94f	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
7e047130-dea0-4b77-bd00-6746b934b94f	b9371a26-352d-4467-9d38-01aa81dc29a2	f
7e047130-dea0-4b77-bd00-6746b934b94f	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
a6fad9c7-8475-49b0-91c9-be60736ac6ec	520dab19-2b7f-4aeb-b74e-df9953057b57	t
a6fad9c7-8475-49b0-91c9-be60736ac6ec	4aa77aa5-671c-4088-97cc-851999012be7	t
a6fad9c7-8475-49b0-91c9-be60736ac6ec	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
a6fad9c7-8475-49b0-91c9-be60736ac6ec	06112d62-6860-4127-b75b-62969292df52	t
a6fad9c7-8475-49b0-91c9-be60736ac6ec	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
a6fad9c7-8475-49b0-91c9-be60736ac6ec	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
a6fad9c7-8475-49b0-91c9-be60736ac6ec	9a724b01-3203-4cce-bb10-3a9906087bcd	f
a6fad9c7-8475-49b0-91c9-be60736ac6ec	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
a6fad9c7-8475-49b0-91c9-be60736ac6ec	b9371a26-352d-4467-9d38-01aa81dc29a2	f
a6fad9c7-8475-49b0-91c9-be60736ac6ec	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
caf4db36-734a-456b-89dd-d093baa1450b	520dab19-2b7f-4aeb-b74e-df9953057b57	t
caf4db36-734a-456b-89dd-d093baa1450b	4aa77aa5-671c-4088-97cc-851999012be7	t
caf4db36-734a-456b-89dd-d093baa1450b	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
caf4db36-734a-456b-89dd-d093baa1450b	06112d62-6860-4127-b75b-62969292df52	t
caf4db36-734a-456b-89dd-d093baa1450b	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
caf4db36-734a-456b-89dd-d093baa1450b	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
caf4db36-734a-456b-89dd-d093baa1450b	9a724b01-3203-4cce-bb10-3a9906087bcd	f
caf4db36-734a-456b-89dd-d093baa1450b	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
caf4db36-734a-456b-89dd-d093baa1450b	b9371a26-352d-4467-9d38-01aa81dc29a2	f
caf4db36-734a-456b-89dd-d093baa1450b	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
a145efeb-53a4-4adb-9420-cc3a6d59354d	520dab19-2b7f-4aeb-b74e-df9953057b57	t
a145efeb-53a4-4adb-9420-cc3a6d59354d	4aa77aa5-671c-4088-97cc-851999012be7	t
a145efeb-53a4-4adb-9420-cc3a6d59354d	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
a145efeb-53a4-4adb-9420-cc3a6d59354d	06112d62-6860-4127-b75b-62969292df52	t
a145efeb-53a4-4adb-9420-cc3a6d59354d	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
a145efeb-53a4-4adb-9420-cc3a6d59354d	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
a145efeb-53a4-4adb-9420-cc3a6d59354d	9a724b01-3203-4cce-bb10-3a9906087bcd	f
a145efeb-53a4-4adb-9420-cc3a6d59354d	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
a145efeb-53a4-4adb-9420-cc3a6d59354d	b9371a26-352d-4467-9d38-01aa81dc29a2	f
a145efeb-53a4-4adb-9420-cc3a6d59354d	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
132dc426-0436-4e8b-8ea1-6e64ff9432d0	004c1da0-580d-4c27-bc3b-ccaac887836b	t
132dc426-0436-4e8b-8ea1-6e64ff9432d0	09b3d3f2-3043-4971-b195-a289348e772b	t
132dc426-0436-4e8b-8ea1-6e64ff9432d0	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
132dc426-0436-4e8b-8ea1-6e64ff9432d0	0b39130e-8344-443a-a056-6847466aeb84	t
132dc426-0436-4e8b-8ea1-6e64ff9432d0	37523f14-c9c0-40e2-9849-6e43373267d9	t
132dc426-0436-4e8b-8ea1-6e64ff9432d0	600aaf34-ed49-403f-a5b5-11af5f66006f	t
132dc426-0436-4e8b-8ea1-6e64ff9432d0	fdc55342-8c8f-443b-82bd-b247fef073cf	f
132dc426-0436-4e8b-8ea1-6e64ff9432d0	98980e62-59c7-4263-8eaf-d247f31fa096	f
132dc426-0436-4e8b-8ea1-6e64ff9432d0	90649879-c0b5-43db-895e-704a0be0026b	f
132dc426-0436-4e8b-8ea1-6e64ff9432d0	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
237dc447-55be-4469-bbcd-39dd7f9f4d17	004c1da0-580d-4c27-bc3b-ccaac887836b	t
237dc447-55be-4469-bbcd-39dd7f9f4d17	09b3d3f2-3043-4971-b195-a289348e772b	t
237dc447-55be-4469-bbcd-39dd7f9f4d17	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
237dc447-55be-4469-bbcd-39dd7f9f4d17	0b39130e-8344-443a-a056-6847466aeb84	t
237dc447-55be-4469-bbcd-39dd7f9f4d17	37523f14-c9c0-40e2-9849-6e43373267d9	t
237dc447-55be-4469-bbcd-39dd7f9f4d17	600aaf34-ed49-403f-a5b5-11af5f66006f	t
237dc447-55be-4469-bbcd-39dd7f9f4d17	fdc55342-8c8f-443b-82bd-b247fef073cf	f
237dc447-55be-4469-bbcd-39dd7f9f4d17	98980e62-59c7-4263-8eaf-d247f31fa096	f
237dc447-55be-4469-bbcd-39dd7f9f4d17	90649879-c0b5-43db-895e-704a0be0026b	f
237dc447-55be-4469-bbcd-39dd7f9f4d17	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
bb000d67-c081-4eee-9b15-4680a04065e0	004c1da0-580d-4c27-bc3b-ccaac887836b	t
bb000d67-c081-4eee-9b15-4680a04065e0	09b3d3f2-3043-4971-b195-a289348e772b	t
bb000d67-c081-4eee-9b15-4680a04065e0	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
bb000d67-c081-4eee-9b15-4680a04065e0	0b39130e-8344-443a-a056-6847466aeb84	t
bb000d67-c081-4eee-9b15-4680a04065e0	37523f14-c9c0-40e2-9849-6e43373267d9	t
bb000d67-c081-4eee-9b15-4680a04065e0	600aaf34-ed49-403f-a5b5-11af5f66006f	t
bb000d67-c081-4eee-9b15-4680a04065e0	fdc55342-8c8f-443b-82bd-b247fef073cf	f
bb000d67-c081-4eee-9b15-4680a04065e0	98980e62-59c7-4263-8eaf-d247f31fa096	f
bb000d67-c081-4eee-9b15-4680a04065e0	90649879-c0b5-43db-895e-704a0be0026b	f
bb000d67-c081-4eee-9b15-4680a04065e0	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
0728eec4-be95-424c-bcc2-af168326f808	004c1da0-580d-4c27-bc3b-ccaac887836b	t
0728eec4-be95-424c-bcc2-af168326f808	09b3d3f2-3043-4971-b195-a289348e772b	t
0728eec4-be95-424c-bcc2-af168326f808	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
0728eec4-be95-424c-bcc2-af168326f808	0b39130e-8344-443a-a056-6847466aeb84	t
0728eec4-be95-424c-bcc2-af168326f808	37523f14-c9c0-40e2-9849-6e43373267d9	t
0728eec4-be95-424c-bcc2-af168326f808	600aaf34-ed49-403f-a5b5-11af5f66006f	t
0728eec4-be95-424c-bcc2-af168326f808	fdc55342-8c8f-443b-82bd-b247fef073cf	f
0728eec4-be95-424c-bcc2-af168326f808	98980e62-59c7-4263-8eaf-d247f31fa096	f
0728eec4-be95-424c-bcc2-af168326f808	90649879-c0b5-43db-895e-704a0be0026b	f
0728eec4-be95-424c-bcc2-af168326f808	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
f89bc995-b3f9-44e1-96b1-c9725e42f424	004c1da0-580d-4c27-bc3b-ccaac887836b	t
f89bc995-b3f9-44e1-96b1-c9725e42f424	09b3d3f2-3043-4971-b195-a289348e772b	t
f89bc995-b3f9-44e1-96b1-c9725e42f424	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
f89bc995-b3f9-44e1-96b1-c9725e42f424	0b39130e-8344-443a-a056-6847466aeb84	t
f89bc995-b3f9-44e1-96b1-c9725e42f424	37523f14-c9c0-40e2-9849-6e43373267d9	t
f89bc995-b3f9-44e1-96b1-c9725e42f424	600aaf34-ed49-403f-a5b5-11af5f66006f	t
f89bc995-b3f9-44e1-96b1-c9725e42f424	fdc55342-8c8f-443b-82bd-b247fef073cf	f
f89bc995-b3f9-44e1-96b1-c9725e42f424	98980e62-59c7-4263-8eaf-d247f31fa096	f
f89bc995-b3f9-44e1-96b1-c9725e42f424	90649879-c0b5-43db-895e-704a0be0026b	f
f89bc995-b3f9-44e1-96b1-c9725e42f424	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
7c86823f-cc1a-43d0-ae29-6e82a14c1256	004c1da0-580d-4c27-bc3b-ccaac887836b	t
7c86823f-cc1a-43d0-ae29-6e82a14c1256	09b3d3f2-3043-4971-b195-a289348e772b	t
7c86823f-cc1a-43d0-ae29-6e82a14c1256	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
7c86823f-cc1a-43d0-ae29-6e82a14c1256	0b39130e-8344-443a-a056-6847466aeb84	t
7c86823f-cc1a-43d0-ae29-6e82a14c1256	37523f14-c9c0-40e2-9849-6e43373267d9	t
7c86823f-cc1a-43d0-ae29-6e82a14c1256	600aaf34-ed49-403f-a5b5-11af5f66006f	t
7c86823f-cc1a-43d0-ae29-6e82a14c1256	fdc55342-8c8f-443b-82bd-b247fef073cf	f
7c86823f-cc1a-43d0-ae29-6e82a14c1256	98980e62-59c7-4263-8eaf-d247f31fa096	f
7c86823f-cc1a-43d0-ae29-6e82a14c1256	90649879-c0b5-43db-895e-704a0be0026b	f
7c86823f-cc1a-43d0-ae29-6e82a14c1256	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	004c1da0-580d-4c27-bc3b-ccaac887836b	t
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	09b3d3f2-3043-4971-b195-a289348e772b	t
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	0b39130e-8344-443a-a056-6847466aeb84	t
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	37523f14-c9c0-40e2-9849-6e43373267d9	t
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	600aaf34-ed49-403f-a5b5-11af5f66006f	t
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	fdc55342-8c8f-443b-82bd-b247fef073cf	f
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	98980e62-59c7-4263-8eaf-d247f31fa096	f
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	90649879-c0b5-43db-895e-704a0be0026b	f
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
9a724b01-3203-4cce-bb10-3a9906087bcd	01d4ec97-99ae-4b0c-be2d-87b1db405eba
98980e62-59c7-4263-8eaf-d247f31fa096	31c16703-1b3f-491f-8f2f-2023cef5b15b
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
3912ef81-f453-4a2b-adb3-b73484455033	Trusted Hosts	54f3ea06-8843-40e5-b3eb-be7e36221acb	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	anonymous
e269d18e-c4b3-4c64-ae8f-4c848e7c2f13	Consent Required	54f3ea06-8843-40e5-b3eb-be7e36221acb	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	anonymous
7ea2689e-0da4-41ac-b262-50e40e7a7615	Full Scope Disabled	54f3ea06-8843-40e5-b3eb-be7e36221acb	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	anonymous
cbddbd8e-90e0-4e9c-97cd-ba7d5d6c29d9	Max Clients Limit	54f3ea06-8843-40e5-b3eb-be7e36221acb	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	anonymous
d9d4af5f-5450-4446-9f79-3d4dbac48ff6	Allowed Protocol Mapper Types	54f3ea06-8843-40e5-b3eb-be7e36221acb	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	anonymous
690d8b52-e132-42a2-9f96-8d71cfe1c573	Allowed Client Scopes	54f3ea06-8843-40e5-b3eb-be7e36221acb	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	anonymous
a88cb7d8-b606-44ba-9b97-279d3a3dbd75	Allowed Protocol Mapper Types	54f3ea06-8843-40e5-b3eb-be7e36221acb	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	authenticated
f160b6bb-adf8-4e80-a563-5ad553abe949	Allowed Client Scopes	54f3ea06-8843-40e5-b3eb-be7e36221acb	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	authenticated
de206c5a-87d1-412d-905e-d25aa649271d	rsa-generated	54f3ea06-8843-40e5-b3eb-be7e36221acb	rsa-generated	org.keycloak.keys.KeyProvider	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N
c7c594d4-6b7c-4958-a291-d311bef55f1d	rsa-enc-generated	54f3ea06-8843-40e5-b3eb-be7e36221acb	rsa-enc-generated	org.keycloak.keys.KeyProvider	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N
c4f8316d-f6fe-4651-a343-e64bbe9e2975	hmac-generated-hs512	54f3ea06-8843-40e5-b3eb-be7e36221acb	hmac-generated	org.keycloak.keys.KeyProvider	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N
5dc6b5c2-b074-4eca-915c-95de1ee3ae48	aes-generated	54f3ea06-8843-40e5-b3eb-be7e36221acb	aes-generated	org.keycloak.keys.KeyProvider	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N
bc2c1f4f-44c0-4555-91ff-6b134cec96f4	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N
68baa701-b65f-4cab-8493-1379fb28c7b4	rsa-generated	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	rsa-generated	org.keycloak.keys.KeyProvider	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N
ad9a3d16-9f18-4624-b939-32407dfcd3f6	rsa-enc-generated	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	rsa-enc-generated	org.keycloak.keys.KeyProvider	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N
3a87abad-3801-4060-aae0-b6629b90b73c	hmac-generated-hs512	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	hmac-generated	org.keycloak.keys.KeyProvider	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N
77b2c50e-e352-4185-8911-ae5f550ecadf	aes-generated	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	aes-generated	org.keycloak.keys.KeyProvider	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N
9838bc58-0086-4e52-aba8-f0c8e5f26897	Trusted Hosts	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	anonymous
1027f0af-98e8-4e01-8f72-3218d271f3a8	Consent Required	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	anonymous
ffba5760-a7de-4e3e-b97a-6726987662d2	Full Scope Disabled	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	anonymous
3702ea87-a1e5-4350-887c-1d0251b3cc9c	Max Clients Limit	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	anonymous
7efd33b6-dbda-496e-9f59-8075ba20c1fb	Allowed Protocol Mapper Types	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	anonymous
601d3b06-604e-4e8c-b914-4d2ce7d98411	Allowed Client Scopes	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	anonymous
0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	Allowed Protocol Mapper Types	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	authenticated
91b032cc-c129-4d08-ade2-4c904c7e27e3	Allowed Client Scopes	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
fa583b6d-30c7-4729-bbdf-341fb965dd37	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	oidc-full-name-mapper
b6c61ab7-3035-4ac1-be9c-04f804fbc75e	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
20f2a41a-ccc6-4da9-a615-72bb95656b2d	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
5edc71e4-64c6-42d9-bcfb-b6fd7e9d32ab	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	saml-user-property-mapper
4620bd2d-4990-434a-9c24-a042bb8b6fbc	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	saml-role-list-mapper
98dc8569-11ea-4051-bf78-2d13ee8bb1f7	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	oidc-address-mapper
cb9f8d37-d86f-4595-b205-d6b63a20460e	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	saml-user-attribute-mapper
afe4c012-a394-4966-becb-88d9c5d47e75	d9d4af5f-5450-4446-9f79-3d4dbac48ff6	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
91d54257-66d7-4e86-bf1d-e5fe3a53d372	690d8b52-e132-42a2-9f96-8d71cfe1c573	allow-default-scopes	true
d2a99c91-58f9-4ba9-be46-74dfae3129e2	3912ef81-f453-4a2b-adb3-b73484455033	host-sending-registration-request-must-match	true
35355102-ae00-4628-a2a5-b2d49e3febd1	3912ef81-f453-4a2b-adb3-b73484455033	client-uris-must-match	true
2928d941-ffed-46e5-be87-1ba0a8d3f280	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	oidc-full-name-mapper
b8c660cc-0357-4528-be43-599fd08fda51	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	oidc-address-mapper
0fb5c543-f23d-4bc9-a9f2-3096fc39c3d7	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	saml-user-property-mapper
e98fd8fe-3da3-4943-933c-9334f3ccfc0c	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
7776450e-9fb4-4c85-b5f9-81408e9af9ba	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	saml-user-attribute-mapper
06640232-320a-4aa7-96a6-fad72d3715af	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
dc169e27-0e58-4ce0-b9af-c6e02f5d5f38	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	saml-role-list-mapper
f9db929c-7f2d-49d8-b56d-5dc08bd0fec7	a88cb7d8-b606-44ba-9b97-279d3a3dbd75	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
21d9ec43-810a-4a15-9b6f-19fe3df944b3	cbddbd8e-90e0-4e9c-97cd-ba7d5d6c29d9	max-clients	200
7b5c1cca-65b2-449b-8db9-a5061d7d32b0	f160b6bb-adf8-4e80-a563-5ad553abe949	allow-default-scopes	true
2f834cda-cef2-45ca-9ed8-fde622318786	c4f8316d-f6fe-4651-a343-e64bbe9e2975	kid	a99370e2-3d3d-4f87-8bfc-aecbb5b772f9
e1fc515d-184e-4650-8ee0-7366a1107df8	c4f8316d-f6fe-4651-a343-e64bbe9e2975	secret	Efpx994tPRkNFeXMXMIr2MyWLTg1euS-GtMeE2LYwx2omvcT5JxoX5QoGqT-ACwUzCmk2jfSAQNbttsSRA1qDcKUx1hEkdGpK2N2pyCyrqS_F4jXZZJAEdlJDydZJbvbhAtjDhaNqXOtLwapiYf24Znp-IpJoKUl-8JhN6saxes
60f65b6f-fd6c-45e7-8e9f-20987f9ffab0	c4f8316d-f6fe-4651-a343-e64bbe9e2975	priority	100
dbbd63ef-8c15-4af8-86d2-656bcdb47b5f	c4f8316d-f6fe-4651-a343-e64bbe9e2975	algorithm	HS512
8b02710c-f3fc-42b6-9660-201b692d1f14	c7c594d4-6b7c-4958-a291-d311bef55f1d	privateKey	MIIEpAIBAAKCAQEAukUeuYREcxPfGbbdNNWn/mLhaZTlVqehoJVlyZKBo+fgEFiKPauzJNLwtzOcoTfxYoLupRzrYfA7wIpBqOMSDshIWF+7kZbjFfvMWH/MH2jrJBeb8QuDFsdEqO2pRyH06/MQyVj+5WwCCKeliPOGBzo7NAIMLFN+KgkNWbfLgWoHE4TXRhJHQIV3PZ+g21P7T+2Kw1iZTheg4b7ZLt0n8qZb3BHcqL5teWSk98X2UJDrHL9/X+X/+v3UyfwFBnevLAjnPhBgZc6B8V5BRyymwEScdt7qIWVrXh3yYteOUc26FzhKPAEhuZbrzmkFq2qfWAnZGBxb3TUin9pG0VOSowIDAQABAoIBAEsViKSMchEXLgPOCA3/n+e1kRp/uBB9ovO5tR2TTmm1EsdUAWmJmD1cQEcA6X69L7Kfh7YL2cARV+ytbnk3CvTle/APquqtcV1Pshfsb+orXzmdwLDiDJX2fjFAF8/CGtmvkZEwLBNrvcgiV+JEE78/FFVLDAAkKcOlAXosUb6Yv7ZgI9jUCTkS/zbGmklsLkgK60fs4EpvWSJN6cxiIhMNapNpWLloategi8kgAv1KiVFU/6UbbrOo7G/zGQwamz4bgUYS6hEOW39PNeNpHt1jlHwFSf2CSxH5kX+Vg99krH7ogGdHiEIMNe47zpvAwL1/FgCX8ZKAaMNimrWkSikCgYEA60qO6u9k6+ZHQ0FtuOPogoRLtO+c5ttKaSVxYOW1/wlBk061GOsr4DThqBBz6EcxETTRUF+uu6HQHFk3SZG1vWUjocIDA9ExkpDgUOHFy1LBNbzp4bAJ5Xt5xhwGdDe1pkiSJuX1K5GsCejB9W8zYHph2ic2W0wMsbMDiFA6XJkCgYEAyqoLXIMFsgOVSMw7vc17+kw4C5d8TKatukVEsa9Q82EbHpYnBj1K4My5Gwjhf37VUaYDIoD86s6LX7IaD/hgwS1BIlTT8F8PGBIc4GpLoP5jMisyv0MCfYZNuBDtc7sNtuN9D8ci0jj82o6ZoQajW7PWnzdPe3GU3baVL8tI0psCgYEAi2EBRD5HhE5HDJoniwzG4PnJdwcx5LcmXx7lCMdKhidPhxlqwbYdqZTpz4rffksdz9l/3KKxeUijZQecbqI4DFdrQhkRfCNhwDa+CmuTpZwCA/lCeoSzeBMq0aYsVI/jtPrsSMqT7xk91ijhLKiQwKf+ayIrWu2z31fx0b/kspECgYBb2jvx/vQq3VLgvqfo+2PQapEQN+U/PGAKx3A99A6FcCKBd15Shp8USdUvepPxXAPE0LAlCD8ZEOm8QpVrXZBEnYUi0T2JeRv3NeZek+6ZFhLRXyDN7MoJKEC7RvjH9iReGrbI2uFeVDPNvsnEYKTTYCvK15+vfCgTYLg3BDSKNwKBgQDbBLoUkCwnHZTDk28tsLRc3QF7eLRusF3C20iTi5pgsH1jFEqfNzr4IRA/R0zBkJVmf3v9w2+r5tRb29cQNPJ7E67ybb9pgCbFxkLqjZNBM1xfCUBOAwyswI3B2Ou6KvvoHKwPPbQzaOhwufKXpT+cqZJTompYUtV7pq/V0IPS6Q==
9d7d96b3-64c7-4bec-901a-3fded92cec04	c7c594d4-6b7c-4958-a291-d311bef55f1d	certificate	MIICmzCCAYMCBgGR8I9EGDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwOTE0MTI0MTQ2WhcNMzQwOTE0MTI0MzI2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC6RR65hERzE98Ztt001af+YuFplOVWp6GglWXJkoGj5+AQWIo9q7Mk0vC3M5yhN/Figu6lHOth8DvAikGo4xIOyEhYX7uRluMV+8xYf8wfaOskF5vxC4MWx0So7alHIfTr8xDJWP7lbAIIp6WI84YHOjs0AgwsU34qCQ1Zt8uBagcThNdGEkdAhXc9n6DbU/tP7YrDWJlOF6Dhvtku3SfyplvcEdyovm15ZKT3xfZQkOscv39f5f/6/dTJ/AUGd68sCOc+EGBlzoHxXkFHLKbARJx23uohZWteHfJi145RzboXOEo8ASG5luvOaQWrap9YCdkYHFvdNSKf2kbRU5KjAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAG4nYmnYf39unNF9tl2Ji4RACod3s/VwcaT39YNben9GlMU7BbDEXArCfBQ2vrdQ0SeYL5+iSoLFybY5HU6IY5D7qp/O36r5mdbYUnjxKIrQoV/BIUgtXWdMx+ZbLpz7WzF3ajipDZC922i1wqP6jzAjLvfT1MwxRvMMDYlNz3idgw7MFIXoZ/dIKgl3GiH6zJEeuT4Kzg4LK9vheuMjsGRY3GhDtui3t8WpS4J9vnww60lP0KKYaDnMZciBdU69fjGEUQaXgmnHVcrK+tgI75cwwKZdUqgu6Zs9BDI2Po/swh9xiRTSo9IaDM2Hn0mKBa+hg38HK9UNSouGqLK9diA=
86705771-9883-4270-8c09-2c42080a1567	c7c594d4-6b7c-4958-a291-d311bef55f1d	algorithm	RSA-OAEP
1fb3a622-5b54-421a-8858-fc10d479d238	c7c594d4-6b7c-4958-a291-d311bef55f1d	keyUse	ENC
78a92451-3299-4af2-90ca-37c1576548a2	c7c594d4-6b7c-4958-a291-d311bef55f1d	priority	100
6fc6f0b5-c604-4d6d-b490-7352ef75401b	de206c5a-87d1-412d-905e-d25aa649271d	certificate	MIICmzCCAYMCBgGR8I9BqTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwOTE0MTI0MTQ1WhcNMzQwOTE0MTI0MzI1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDb0P0fCsyGfcDvuOuVyIFx8NJ2hjxjWmZ63vKjjul3CwoUVAivNbLtjRC3gMnmYGYUW4LpzUUZELAW5Jd+vhUPa1aGEfnvLWVMDvtW+VBRxQwzJVUQQg93AL5iohMjz1CCeHIWBowprOPa9o7QyHfSP0xs+pAt8cV1VCKdUI3VvTfdu7V+212etupXkn0PwB4P+DDabV6gKki/EwM3bGe8VNrxM6WyTiX5f6tLjZJSEGZxs21mDYKtQ+RG5QViS5zPnn5Awr+EID0K9AmG0EzHuXKUlNwZDpjwqJ9o1Qj2zIwptChsyGYDtN0PIaDMtVTN6XTPekmzvZpvBdD8l5grAgMBAAEwDQYJKoZIhvcNAQELBQADggEBABgBm/dWsWMQ6JLZHC0MnL4WCWaz1B+SaGnjMWOrXEX6mYILobw+PbMn42J8F7lJ8qm0mXDZl3Rb5tyTai7RARMwZvZ1k42hR7kNauJb8M/7pD2lau5J1xerKATqw0NmcDegJJ+9ruYJkR26L/S4pOJshCTpBwo7ICrKFn++GN4KclZMdMAvPS69dWeBsc6YltHyUfBq9FPcj9FWRHR6b3C40itnaDGxY0jcYktBJ8cHlO0QigrJ+B5fhlgDaM+N5YwqxcMuVOgaJNKc+CVJ+4kfmHdQ4+fEhDL0fvo1+ov94Yoy0GoqZGvrYqXDDurAZnJMSDNuRROCTn6opYfXVvY=
e5babeb6-deca-4a87-8b1b-fa32487fe4d0	de206c5a-87d1-412d-905e-d25aa649271d	priority	100
643f139c-130b-44c4-aef2-ddba877aa385	de206c5a-87d1-412d-905e-d25aa649271d	privateKey	MIIEpAIBAAKCAQEA29D9HwrMhn3A77jrlciBcfDSdoY8Y1pmet7yo47pdwsKFFQIrzWy7Y0Qt4DJ5mBmFFuC6c1FGRCwFuSXfr4VD2tWhhH57y1lTA77VvlQUcUMMyVVEEIPdwC+YqITI89QgnhyFgaMKazj2vaO0Mh30j9MbPqQLfHFdVQinVCN1b033bu1fttdnrbqV5J9D8AeD/gw2m1eoCpIvxMDN2xnvFTa8TOlsk4l+X+rS42SUhBmcbNtZg2CrUPkRuUFYkucz55+QMK/hCA9CvQJhtBMx7lylJTcGQ6Y8KifaNUI9syMKbQobMhmA7TdDyGgzLVUzel0z3pJs72abwXQ/JeYKwIDAQABAoIBAC8oHP1JWEor9TWYUrX930M92jDCKHdZ/+0xIhWThaNbs2xcAMbxurJ6llD/qJCrMosAfMvClSXE7jnjDVsL1UHLEbNObPNyJi6Ucjgc4S3Bm5XnVuHXgjDR8IYBZiDDC28J/tOZ0Pzp0bH6PfYtY4MvwCoK8N5iZS2AALMGAn+NJAOyaFMzJD92aNhR7TBhYkr+GU0xZnaK1aNKLLDmR7xfcbes6WxRI7GiKh7MCR6C2UJXz4PiZ3GEzSfzsCB2ehPMuhw1dhlDmrL75YDf5sT56UlOwTTboHpuLYTBdG5jAevlFvcEXtePzh+C4QgB4/la6Fcj/6LKSxUr1ZzoD5kCgYEA7vYpnol59fdEM1o+19T/0SBmKRTYxUZ77BBJacx/aYOrwQCknh5fLgqvUnCs84LiD7z2T55vy5+IHLTboF4F/XslFoCdcwPtc093OQNFuuuhuP1tkOcFjA6n9E2qX1t1qQ3QpTaxam2ipboDBG+zT4sZU1DRNYZ2iEr/fiTDK2kCgYEA631c5xrmPFD9+cFcnOTC0bjpNzCo8/4Pe2OLhLH7+d3jhWcvAZVJ8jqLfNguBDFCwSFU+fOJOYbee0E2d8cSZtC9lDLBuJJ8JmlByt1DukZ9YJWKkwsgj20oLBqvQuMsIN1AekvetBCsnDy/aGPDvULCstnZx/OYTO+huf0nWHMCgYEAxnPDDrnHgsEub6NkC2UGawwIK9f3SqaFpf/EqEvACMXkLu40yGgazabsAYA38ifhTAa3XFoNKEM+C/EbcKyFNwU9QNnhaLJ7UcdOERgpodmsvnAhvTRPRAir7VVOx9Cx/4rMm1i3sNaKPC4l8Vo+xTGU/79fb59S80+trXokZ/kCgYEAqRNzNoL7t2a3UzDfm84rioRm/bc0Nyq8Vu0b6QQZVEdZ6hgxicN0OjSKnfJg56WutheGeYe/iMwqxPgHcWw+7A8HbnYa3Lhf5vw/vrWqwP2HW2dC/VxJ3nCTHUdzemS89EOm3afHmCU4qVx8WSj4CtT6EYuUb5mYSfTreywlqb0CgYAMGxMaS3ebJ/N7ts3N73KAYUUkj78uaqP78vUpslb4z1Tllffz01TpCsUoi0xbl40HWDNZHWGvyJfXullmPdyCaSAGf3nb6EXpl3Bsyy3jNIPCuPMUb6MaC1L+PP5XryHVvy7/2qw65lHrF7Un9rl8MNkyCyDLjj4q6v8npR2ECw==
1dbe9e37-2f4f-498b-865b-e9ea797cdff8	de206c5a-87d1-412d-905e-d25aa649271d	keyUse	SIG
91fe9556-cf5c-4a93-bc47-da6d8f94ae31	5dc6b5c2-b074-4eca-915c-95de1ee3ae48	priority	100
f6a608e9-6c1b-4b32-a242-f2b6b72100e4	5dc6b5c2-b074-4eca-915c-95de1ee3ae48	kid	e7ac46b1-1e5b-4ff7-8e3b-92e8d0f241b2
1d922fe4-2ed2-4d15-8011-caf6426a4ee9	5dc6b5c2-b074-4eca-915c-95de1ee3ae48	secret	h2MqKik6h1uym93Z5UdLxg
428e5830-4501-418f-a873-8eb4ae802e8a	bc2c1f4f-44c0-4555-91ff-6b134cec96f4	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
bdc012e4-074f-49a0-b78a-e5fe85bbd712	77b2c50e-e352-4185-8911-ae5f550ecadf	priority	100
e5bb1249-08a7-413f-a9b4-fc0e76cf0e38	77b2c50e-e352-4185-8911-ae5f550ecadf	secret	_D3t6yRv_xYAFzbL_C308Q
010fbb66-3672-470a-807e-6b31c80ac195	77b2c50e-e352-4185-8911-ae5f550ecadf	kid	e1d1da62-80af-4e32-9061-003012cb9ed0
daf5f8e9-343d-4079-a9c5-47fa9ac24153	ad9a3d16-9f18-4624-b939-32407dfcd3f6	certificate	MIICnzCCAYcCBgGR8JVspDANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhleHRlcm5hbDAeFw0yNDA5MTQxMjQ4MzBaFw0zNDA5MTQxMjUwMTBaMBMxETAPBgNVBAMMCGV4dGVybmFsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAovgFCdy7KwtTR4qiSQQ+K3QHqmjTLMa4DRUZsGexYlze+jUgm7IxcVmd3su+2WpENY7DtBAtsLF4UGXRCVBri+qi9J24ZDv6kXyOytsVHrvjR6gAPicr6amW4M6K6FjzZtriQkKSJqUECBzM60CTFOQzOiFq2/T5tcY4w+IegKkljaMn9Utr6ulICqYhakV5EFKp7EBNwD32QOsGvBg/UsI2xwljpUIGHYy21VHoHR/pjGEd98aDe9abYj6LmOYysYIvRJ70qhdybScht4fRmAJBJ3U8g+qtFOESqAZTA2J6J5UOAwfXkdQukEiaYCXm2Sjc7nMwqixmGTVGyzMKWwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQAMe04g1rIL8s39hJYrv7GZMI25U+QfecTpe3wM1JYk75pm1z1IMdKPRd9Yf3gTFNksubGVtUOw851fDtOkaFMbT4KUEYxbza3hiGA+UUtbV+5VZJTe5SWVnzieR8gzU+tlu7n0Q8bz77PiwESG8qcwv2PVCvuP+uCBx/u+ZvaL1znGpaFLL3yF7fgkF8DO8PPj3dsPdZuRN7uBxZ+GztGnMc9dM4lRQteNZbUYAEQGnH6O4fnqB5Q6eiYaxtuCTrc+l6SeGdnsC/Af++WIXE1o/gnbpY/uDwOy3+yMI/jfr4DVdny/dBWABC47GJ3jJd4Yo0baU9FjkpL3EnNxoEmV
aac434f2-6872-414c-bb5b-20844d9119cb	ad9a3d16-9f18-4624-b939-32407dfcd3f6	algorithm	RSA-OAEP
df6ff248-f674-4c30-9950-a47b5b8b4b2e	ad9a3d16-9f18-4624-b939-32407dfcd3f6	priority	100
2d43bb96-f38a-4290-a8f6-efa781820d6e	ad9a3d16-9f18-4624-b939-32407dfcd3f6	privateKey	MIIEogIBAAKCAQEAovgFCdy7KwtTR4qiSQQ+K3QHqmjTLMa4DRUZsGexYlze+jUgm7IxcVmd3su+2WpENY7DtBAtsLF4UGXRCVBri+qi9J24ZDv6kXyOytsVHrvjR6gAPicr6amW4M6K6FjzZtriQkKSJqUECBzM60CTFOQzOiFq2/T5tcY4w+IegKkljaMn9Utr6ulICqYhakV5EFKp7EBNwD32QOsGvBg/UsI2xwljpUIGHYy21VHoHR/pjGEd98aDe9abYj6LmOYysYIvRJ70qhdybScht4fRmAJBJ3U8g+qtFOESqAZTA2J6J5UOAwfXkdQukEiaYCXm2Sjc7nMwqixmGTVGyzMKWwIDAQABAoIBAEwzlIeMAqiZ3xLwq/lgVoGS+5Ke+T9Sm/TiDOUDV1oa+tgbx2eF5sCNmtf2hQK8QbCZVMD5X6PjF9LgCOJGDEOcLx4aMYIM2Zj1mP8ZecKpMBjtYU+umUXk2nu7mBAUp5tMdcdtwVD4j+4LKXZG938pRRrFTWYUIj7wtNJDBOg7cBt74aPNOGXusW1F1Z5y3QtABdNIyoLCUY3BtXZ1DzLW4mrB+McE2a1gk0QctIMLq+nbFqi4VJXAh/cTI1JkcC5Bbalt+IKkP1aVDyJb0OGfngGCJ7d6ci2q9QediP5ZiuSmg82WodsM8z2yu3VctpE43NPdxoqE790syG5dNsECgYEA0BZLFvNp8BAqg4u+HMy6KpH+wsoYk2ZgzmDhqGboNUip8EAgANC/Gy2QlBXkxZyjEZb/fpN1+13O4MRbgN0SPAoNvoT526k+sjeBq5Nr0+AUiOsWVAqDaANUH6rfzMxIgznVaf87GzHYMXz3r6jqQVetSellebUlvojWDbyZOPMCgYEAyH46URoVYI+IierySTdSEbm7hFP9cRLQhZs9PJTKaEX+CI9c15xb4cvX6EwkLrNpgSGIP0n9v9Z6KhiH9pq/hlqVqBhVhJkETwoRjERub0mVtHvcG428VUY89k8ZODkm62pPyyTlCK7bJ6iivjRw+qIzpVvp1tViqY0gDZ+UQvkCgYAcZe55g17B1HL44OlhJM+DX8lU7B/OffpYMACb6u9l1jTbBOVZNyPdoapJi3NdRLM8g077B0TiuTqykhmqzIDgkL6vcZZn1AEqcUjREZ11nO8wgGTbs1ObrlicucUxPe/neM0XWi3G2FaY6mUjI/pUUJLls2SV55LvHd2YolSG4QKBgAS954cvhL3p5yLL6bsNkeVVbTft/JqGBWSDjWk3Y6ofrahqK5n12r52Yb7eviRUnfQt5NkKWPQGkJEaT2znsAvvbIazPKKMM+vioxOcMrhzFxVTsJr+OSwTIzH4IPKRd3gt5YE6eChCanB/romtF9b1qx8IE3m/RjwYWF+6HHmRAoGANEjqe10ZZbsuLwS8w2iWJIv2Lgr9qOX+xe1t2mmPDYVJwRlFS5vrnvRruC6YhhNVLIwUuF5LtR0p8++XdG7pm3iwoFJbFG31IP9z+B9T6F4VVFVl0bAvJIZNSkD9iGk8NxXTFgI093fO0B7j6ljnb6DfnOL3zv/xgMWI10rGB+c=
9e06486f-b7d5-4560-ba05-8142d4cdabd6	ad9a3d16-9f18-4624-b939-32407dfcd3f6	keyUse	ENC
efe2e576-5f2b-4d3a-a97a-08544f9ad801	68baa701-b65f-4cab-8493-1379fb28c7b4	privateKey	MIIEowIBAAKCAQEAxZ1NpGKOMLTu3CLOpJymieMqUCgrYbhFGn4FGNxm+NFYuu6T1tNeCULBBLfzn/DdKlOUe+pED42L5RR/fqgca+/NkdzpjJfpHaEjSZAezsrr5o0hlxc2zFVSbCS/9+881j5C9rACJ+mM8xhTfa03nN3SGjmSLc7ao8iqPms0HuaK4Fp074G4U0BGvRMmj/MGDaxbuc5vwLt6lCgnyZ4c8ptd3M6gJuYT7IvZMcnb8Kz6wKSj2J7QuTngEz2LF8TeLh5dIrGdObshcLqQscv0G7IE485ee56mnLlPvebhSU9bhWXXGV8tXemJBpjQoQWQZglWqwHapyhXK/SoxynK+QIDAQABAoIBAAoV4OZMnF6qgU1NXngCwbIkXJ66Khqi5a34NAjkiMHWp11k+zkZ0QEOfdzgiYfGanc0TE31sxMLIZJntSkQ6eBtXPO+j1HcV+qp9GvW9eeObjM2TTpRljuf+CSqTHzaIiP6Cf9elMGWNxoaCfrOShoQrR4nBYmedsSoo12rqX2RJfwWiXcK1a0VDmpELBd7IeORra2zIZAYAVUXeDg3gZ3a0IyZSRS+4Qjf0CGnWH6NF0CP97YpoP9XG3NncrgvL1spVurBVAfOOPDppC7lhZSxefVzn425vR4pDLy77YLqv1yRxqVn9e8NiIcxY6thDxpLTUisF/G1xaxNq32Wue0CgYEA+cyaO3PWprEl/3wHsqnjmIOJ/VxHcBfMCDMOXCR/7pO52lwGKoi31wgK/oLhGxI4fseScXaBQCDOUP6eyA5jb294GyaLrgZiOC1VdwkMxyfSUQtuRGKp6lOSlJViu2Zp2Rsc0cCUqWOKxZptDd8r2yPTBOhz2amuGSfcx/6utRUCgYEAyoUVKIsCoW9g52KF+0hMcEKpcGFUnd2WkqbXhzS0ayb+kTDaFnDQ2/7TK5YX8mCyYVN28BxTPm8yTjHYolhHgJb85IF/IvL1qTW6AvtfcpXrUxtb33Fano76sP7KWknR86q9HMDkvfRTgZBDzd9445gr5304hXQ1nanUMjMZv1UCgYBSBm1euFrzwZfInOGqOT8TBZ56I6MRm77TsnA0sYeQv9F3cmBT9zDm2y1BBZkFWqZSexYLS+6FMECPOAzLhG4CWYgG4lFbg50c9UXrIH2hp+HX2vkKW5uP5oFraOJSxv5a3BxKhAJM3PLkkCDfPTkZbFoOcoYYIy+X8w78XRThQQKBgQCx1SK7MzXgJDlndTBJczcL7L10nUL8TLQHmtHvO+yhmuA3Bjq7Md11ENLFl0r33slEhVIPjg/a5zG5UDP2eqZu2CbBUKUfP1FQgIkSTUGHEPZPR9ro3lTAnrSr71Ao8GGYIfll4kv6MS2Su+eORAmXcOw8ncygA2eBRru6SPz28QKBgHeJ1e4srWft7bV8EYdgtj+tKkW8fUafAkcOxv6E7mhf0aDHVh8/KQRRCAKOc9icuKnLeet48lWy1KQfgmgPH6xfm0w6u/s3ozHzkzMsPIvcIKLVVWxd2iXZb60qMR+MVjb9MXMKr+I5WxXVenYkepB5cXPMzk6E1d3661tbyOXN
0c73b44e-facf-45c0-8a71-a2a0efb47c92	68baa701-b65f-4cab-8493-1379fb28c7b4	priority	100
339bc849-c609-41ac-a90c-dc9af61e029c	68baa701-b65f-4cab-8493-1379fb28c7b4	certificate	MIICnzCCAYcCBgGR8JVsITANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAhleHRlcm5hbDAeFw0yNDA5MTQxMjQ4MzBaFw0zNDA5MTQxMjUwMTBaMBMxETAPBgNVBAMMCGV4dGVybmFsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxZ1NpGKOMLTu3CLOpJymieMqUCgrYbhFGn4FGNxm+NFYuu6T1tNeCULBBLfzn/DdKlOUe+pED42L5RR/fqgca+/NkdzpjJfpHaEjSZAezsrr5o0hlxc2zFVSbCS/9+881j5C9rACJ+mM8xhTfa03nN3SGjmSLc7ao8iqPms0HuaK4Fp074G4U0BGvRMmj/MGDaxbuc5vwLt6lCgnyZ4c8ptd3M6gJuYT7IvZMcnb8Kz6wKSj2J7QuTngEz2LF8TeLh5dIrGdObshcLqQscv0G7IE485ee56mnLlPvebhSU9bhWXXGV8tXemJBpjQoQWQZglWqwHapyhXK/SoxynK+QIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQC1cYf+QG8a+wLk/gw8SY+bmdMpFxx00HfSIt43HTlxikcf0hKor+jQAgK23rgYxPzYoJ2cB8DlKjEv0iKn+z759lHUoJcVgUgO32CSEdaG873KgIADExeszGG45aT6hM6n0sHStUkds8ugdvQJ4jdenSdp7j8MiX3dWqwx6gNOy4qw+7uC3ouoKUbb63oS9algVDuIDykKIptDrikMo1baXwjwMl/sN7RM5x5djsSaeBNPDfffuy5xR+s9JNpFEJdbPHe3vJEQJ7vxFUocVN0oB3dV+9noITSGvgzqqwQjLBKzspGwKcVg9clCIfBziQfmPieIEAWEjHljG64jNjAq
28085092-63b5-43d9-9150-6bcc9c468740	68baa701-b65f-4cab-8493-1379fb28c7b4	keyUse	SIG
ee439b30-0e1a-4481-8a17-374786e22d0f	3a87abad-3801-4060-aae0-b6629b90b73c	priority	100
1de8f28a-eb08-471c-9037-38503d391fba	3a87abad-3801-4060-aae0-b6629b90b73c	secret	DoM2boqQIX96eu2ZjOJSrnLnpL30e4t8nplDbwzEz5fh17dgUR_nT2qvU1ZpRTLv9DzY8jggT2aab4MLM34Fp9CjilVDf9cASoMV4ld_XMHCHEg_ciI6oN_VHxNNfQAw6Jkru7AhcvTuH5_l9ZbawVuTEwX_w6U4dU-CSWwVrWI
c7bf0e93-744f-49bb-ba33-aac161085559	3a87abad-3801-4060-aae0-b6629b90b73c	algorithm	HS512
e67a03fd-0e82-4b41-abdc-86a78387b889	3a87abad-3801-4060-aae0-b6629b90b73c	kid	a5530115-0c95-469a-9c17-7dd1b9d342e8
0624bdce-2774-4b0b-9996-f8edc5a6900a	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
2f236b2a-e1db-4003-ba13-4c8672761229	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	saml-user-attribute-mapper
18811475-d7af-40d1-9cb3-056a28dd87f0	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	oidc-address-mapper
1e804968-76c1-4beb-a820-e426ab8a5c3c	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	saml-user-property-mapper
ca955843-76e7-4cc2-a75f-14c0f40b86a8	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
cad26b0f-3c4b-494e-b358-6b838a82fc18	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	oidc-full-name-mapper
5dc075ab-8c63-4e65-81b8-110f98f62c17	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	saml-role-list-mapper
64fdffdd-3cba-45ff-8c99-de79eef63ede	0ecf7b9a-0ac6-4886-aa6d-0a28aa7898a5	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
66de936d-7ea1-4d13-a28f-cc7e91a77d33	9838bc58-0086-4e52-aba8-f0c8e5f26897	host-sending-registration-request-must-match	true
07c68ece-f8ab-4237-9635-5efbc4ee08ff	9838bc58-0086-4e52-aba8-f0c8e5f26897	client-uris-must-match	true
4002f00b-5c2b-4798-8cd3-cc323ec0546e	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
dcef4d14-179d-4219-9335-9e01700ed9e3	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	oidc-address-mapper
6e760536-9379-4853-b4e9-677ea2809e46	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	oidc-full-name-mapper
73764d63-f949-4c74-9929-57eb504c773d	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
76e07714-9edf-42dd-8119-6d8d11a48789	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	saml-user-property-mapper
6e4ecd31-2156-4c9e-a567-93cd0618df10	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
4946d064-da3c-45be-bc2a-d16939ee6411	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	saml-role-list-mapper
3dd7c0b9-ae1b-4f6c-a334-a93531a58f73	7efd33b6-dbda-496e-9f59-8075ba20c1fb	allowed-protocol-mapper-types	saml-user-attribute-mapper
bcf62102-226b-4e07-90ce-64060241a823	91b032cc-c129-4d08-ade2-4c904c7e27e3	allow-default-scopes	true
507aeeb1-773a-4c6f-852e-258566be7d50	3702ea87-a1e5-4350-887c-1d0251b3cc9c	max-clients	200
6443ee04-f47e-4d3f-b289-399c33115185	601d3b06-604e-4e8c-b914-4d2ce7d98411	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.composite_role (composite, child_role) FROM stdin;
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	a970e4ff-25b3-4a8e-8b98-126bec650869
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	583525be-1dd8-4b74-a628-de638dca486b
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	f70b6af0-9068-4681-ac3f-6271ecee1f20
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	3b61530c-a479-4816-b4c1-0c8e83e0bf88
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	89851a5c-040f-4826-80da-7eba4eacaae8
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	baf86233-f857-4d86-8201-a02adc337c79
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	2935502f-83ea-45be-ad82-388d0611b8c9
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	bd81bdae-fc80-4a6e-b7e7-cbd683a5f459
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	bae6c163-e0dc-4614-9925-7aa148122e09
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	b29279d2-4759-445f-9d17-86cb9d19d4a3
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	84830ac9-47bd-4f4a-a762-ca751c3c07ab
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	ff884416-8f83-4784-8fa4-c89e3dd9b5f1
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	1fef15df-1538-45ed-a74d-2ea10bc7824b
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	82f3e9f0-5f1d-49b7-8ab7-d6a6177de161
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	00784c1f-c60e-4a97-83a3-a90cabc6d136
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	5929753d-0f91-4386-9fe3-3b970d4cb18d
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	d86682f2-25ab-458a-88f9-0a7ded135406
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	054fccd6-a62e-4b44-bf3b-d1ff03ac2b27
3b61530c-a479-4816-b4c1-0c8e83e0bf88	00784c1f-c60e-4a97-83a3-a90cabc6d136
3b61530c-a479-4816-b4c1-0c8e83e0bf88	054fccd6-a62e-4b44-bf3b-d1ff03ac2b27
587b2229-82a3-4623-b95e-38f548cca93c	3e16eab4-928b-4d51-b530-51933394a1a9
89851a5c-040f-4826-80da-7eba4eacaae8	5929753d-0f91-4386-9fe3-3b970d4cb18d
587b2229-82a3-4623-b95e-38f548cca93c	5e619651-6834-4cb8-be40-74beca98c6ed
5e619651-6834-4cb8-be40-74beca98c6ed	8ff2a79e-f9b3-4cd0-856d-9f2af412d0fe
bb56fbb5-edf5-4bea-9ef3-679dde1f4bfe	83c8181f-323d-49c2-9a22-ad98e46f8cb1
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	a4d892a4-bca3-4abc-99db-1eaa93ea72d3
587b2229-82a3-4623-b95e-38f548cca93c	01d4ec97-99ae-4b0c-be2d-87b1db405eba
587b2229-82a3-4623-b95e-38f548cca93c	4a78f328-2a71-4e08-a65f-d1e085edfb15
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	0d0f7ba7-530b-49bb-81a5-786f7da6b54b
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	0ce2a441-ff47-4ff7-b044-e4b12b91e325
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	53e75358-bdd4-4cec-9279-894324efcdcb
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	1e651586-b6c5-4b18-ab3a-57e2d6c73cf4
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	379d7cc7-2666-470e-9667-d3c69990328c
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	b5e37726-b902-47fa-8347-993ecd17db43
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	e21ab6b9-9c5a-4d1a-a166-f2206d95a871
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	3711e43c-bc39-4af0-b8f5-60a9ebdc3ee0
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	9f385631-1576-49e2-bd38-46f179e1e919
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	6e98eb80-9de0-47c2-ad27-b219c77df833
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	15a99b7c-096c-41bb-95c2-00019376efed
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	23f8660c-b9f4-4f29-81a8-062fb5d3c6ac
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	da5c70f1-afae-4edd-a324-561295543f93
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	2b6b7e72-75a9-4197-902c-2a01f4e69ff1
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	5e6fb253-00b3-44ed-8af7-7a219ab7dcb3
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	31667125-25da-4862-a2ec-92813aa74c68
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	c706463d-d080-43e9-a5be-5b2aec1cf097
1e651586-b6c5-4b18-ab3a-57e2d6c73cf4	5e6fb253-00b3-44ed-8af7-7a219ab7dcb3
53e75358-bdd4-4cec-9279-894324efcdcb	2b6b7e72-75a9-4197-902c-2a01f4e69ff1
53e75358-bdd4-4cec-9279-894324efcdcb	c706463d-d080-43e9-a5be-5b2aec1cf097
8dc4d997-db13-4766-9804-0a7aedf6de64	03efef7a-f8d3-42bd-b083-63a6a606c2b0
8dc4d997-db13-4766-9804-0a7aedf6de64	89ea05e4-42aa-4f32-8d57-b8c84b5b658c
8dc4d997-db13-4766-9804-0a7aedf6de64	794fc65d-d801-4c10-b116-b4d0c34137c7
8dc4d997-db13-4766-9804-0a7aedf6de64	65b38f88-0e4c-4b71-8afb-766b40dada42
8dc4d997-db13-4766-9804-0a7aedf6de64	21a53032-3ea0-460c-b645-7fe741ecc4fc
8dc4d997-db13-4766-9804-0a7aedf6de64	676656fb-0bb6-4ae8-add3-fc89ff4fc984
8dc4d997-db13-4766-9804-0a7aedf6de64	b7bf644f-1592-4e57-94e6-52844f328b8c
8dc4d997-db13-4766-9804-0a7aedf6de64	c9c2ded5-c8b9-4603-a8c7-7543922488f9
8dc4d997-db13-4766-9804-0a7aedf6de64	2ad02993-f469-416c-94f8-bff031d48bb8
8dc4d997-db13-4766-9804-0a7aedf6de64	69d1d216-50bd-4e3d-80a8-7b5aee9f6a7d
8dc4d997-db13-4766-9804-0a7aedf6de64	292ff663-8324-441c-bd31-7b4f848cfbcf
8dc4d997-db13-4766-9804-0a7aedf6de64	2f42cb4a-f5eb-47b9-967d-9580d8a8290e
8dc4d997-db13-4766-9804-0a7aedf6de64	500d7197-b7be-4506-bf05-7d0bafb44b51
8dc4d997-db13-4766-9804-0a7aedf6de64	fec0458f-4d86-4d5c-b842-db6c3340fc8c
8dc4d997-db13-4766-9804-0a7aedf6de64	2e80d874-da3b-480f-8399-00c0a9ca299d
8dc4d997-db13-4766-9804-0a7aedf6de64	466b8dc0-fd26-4eb9-9bae-7997608fce80
8dc4d997-db13-4766-9804-0a7aedf6de64	444dfaf6-cdf2-4be3-87ac-a42da7486506
26b73ed3-d707-4d6d-858c-905be5d4d375	372c3eaf-bad2-4ab4-94dc-4d5690351fae
65b38f88-0e4c-4b71-8afb-766b40dada42	2e80d874-da3b-480f-8399-00c0a9ca299d
794fc65d-d801-4c10-b116-b4d0c34137c7	444dfaf6-cdf2-4be3-87ac-a42da7486506
794fc65d-d801-4c10-b116-b4d0c34137c7	fec0458f-4d86-4d5c-b842-db6c3340fc8c
26b73ed3-d707-4d6d-858c-905be5d4d375	048a7b32-c773-4dbd-a3ca-95e3340e194a
048a7b32-c773-4dbd-a3ca-95e3340e194a	f6f5c408-57db-4cc0-af4e-63b2de9ed4bc
d31f1f07-deb9-44f8-ba93-233c0f40f466	3d4308e1-ad69-4d54-a678-6802a82b8b4c
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	15130fd3-fdfd-470d-a780-5b5d72ba9e3d
8dc4d997-db13-4766-9804-0a7aedf6de64	9967fea2-2fb0-4f1a-8d17-1aae98fcbaee
26b73ed3-d707-4d6d-858c-905be5d4d375	31c16703-1b3f-491f-8f2f-2023cef5b15b
26b73ed3-d707-4d6d-858c-905be5d4d375	cf5b9baa-0c15-49d2-b9f5-edfd462dcc8d
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
e117f236-9f24-42b9-8309-479fae8b85d8	\N	password	7938682c-2c82-4039-b7ce-b348607917df	1726317807289	\N	{"value":"mT5yFGWPbWDlAkSaG7CNTaefj2zLf1W1BETxouQTN4g=","salt":"0FnXnjpms/SZz8hpWqBMEg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2024-09-14 12:43:20.805656	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	6317800051
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2024-09-14 12:43:20.823342	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	6317800051
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2024-09-14 12:43:20.896369	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.25.1	\N	\N	6317800051
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2024-09-14 12:43:20.902942	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	6317800051
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2024-09-14 12:43:21.07073	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	6317800051
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2024-09-14 12:43:21.07785	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	6317800051
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2024-09-14 12:43:21.212589	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	6317800051
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2024-09-14 12:43:21.219526	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	6317800051
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2024-09-14 12:43:21.228721	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.25.1	\N	\N	6317800051
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2024-09-14 12:43:21.365495	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.25.1	\N	\N	6317800051
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2024-09-14 12:43:21.44482	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	6317800051
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2024-09-14 12:43:21.451426	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	6317800051
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2024-09-14 12:43:21.489976	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	6317800051
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-09-14 12:43:21.517428	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.25.1	\N	\N	6317800051
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-09-14 12:43:21.519615	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-09-14 12:43:21.523285	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.25.1	\N	\N	6317800051
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-09-14 12:43:21.527036	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.25.1	\N	\N	6317800051
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2024-09-14 12:43:21.591557	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.25.1	\N	\N	6317800051
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2024-09-14 12:43:21.656429	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	6317800051
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2024-09-14 12:43:21.662455	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	6317800051
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2024-09-14 12:43:21.667081	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	6317800051
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2024-09-14 12:43:21.670598	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	6317800051
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2024-09-14 12:43:21.712869	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.25.1	\N	\N	6317800051
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2024-09-14 12:43:21.720776	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	6317800051
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2024-09-14 12:43:21.722796	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	6317800051
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2024-09-14 12:43:21.756311	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.25.1	\N	\N	6317800051
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2024-09-14 12:43:21.871743	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.25.1	\N	\N	6317800051
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2024-09-14 12:43:21.876933	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	6317800051
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2024-09-14 12:43:21.965633	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.25.1	\N	\N	6317800051
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2024-09-14 12:43:21.98698	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.25.1	\N	\N	6317800051
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2024-09-14 12:43:22.017075	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.25.1	\N	\N	6317800051
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2024-09-14 12:43:22.027649	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.25.1	\N	\N	6317800051
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-09-14 12:43:22.039538	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-09-14 12:43:22.042498	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	6317800051
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-09-14 12:43:22.087987	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	6317800051
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2024-09-14 12:43:22.095035	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.25.1	\N	\N	6317800051
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-09-14 12:43:22.10156	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	6317800051
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2024-09-14 12:43:22.106105	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.25.1	\N	\N	6317800051
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2024-09-14 12:43:22.110695	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.25.1	\N	\N	6317800051
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-09-14 12:43:22.112298	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	6317800051
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-09-14 12:43:22.116171	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	6317800051
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2024-09-14 12:43:22.126351	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.25.1	\N	\N	6317800051
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-09-14 12:43:22.274452	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.25.1	\N	\N	6317800051
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2024-09-14 12:43:22.279792	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.25.1	\N	\N	6317800051
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-09-14 12:43:22.285997	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	6317800051
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-09-14 12:43:22.295589	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.25.1	\N	\N	6317800051
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-09-14 12:43:22.297369	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	6317800051
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-09-14 12:43:22.356544	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.25.1	\N	\N	6317800051
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-09-14 12:43:22.36308	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.25.1	\N	\N	6317800051
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2024-09-14 12:43:22.424789	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.25.1	\N	\N	6317800051
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2024-09-14 12:43:22.463069	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.25.1	\N	\N	6317800051
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2024-09-14 12:43:22.467879	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2024-09-14 12:43:22.471463	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.25.1	\N	\N	6317800051
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2024-09-14 12:43:22.475088	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.25.1	\N	\N	6317800051
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-09-14 12:43:22.482919	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.25.1	\N	\N	6317800051
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-09-14 12:43:22.492002	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.25.1	\N	\N	6317800051
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-09-14 12:43:22.521129	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.25.1	\N	\N	6317800051
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-09-14 12:43:22.678232	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.25.1	\N	\N	6317800051
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2024-09-14 12:43:22.721374	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.25.1	\N	\N	6317800051
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2024-09-14 12:43:22.729791	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	6317800051
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-09-14 12:43:22.744954	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.25.1	\N	\N	6317800051
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-09-14 12:43:22.751664	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.25.1	\N	\N	6317800051
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2024-09-14 12:43:22.756215	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	6317800051
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2024-09-14 12:43:22.760067	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	6317800051
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2024-09-14 12:43:22.763878	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.25.1	\N	\N	6317800051
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2024-09-14 12:43:22.779885	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.25.1	\N	\N	6317800051
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2024-09-14 12:43:22.787336	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.25.1	\N	\N	6317800051
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2024-09-14 12:43:22.79545	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.25.1	\N	\N	6317800051
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2024-09-14 12:43:22.815106	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.25.1	\N	\N	6317800051
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2024-09-14 12:43:22.821901	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.25.1	\N	\N	6317800051
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2024-09-14 12:43:22.826702	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	6317800051
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-09-14 12:43:22.836507	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	6317800051
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-09-14 12:43:22.845275	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	6317800051
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-09-14 12:43:22.847718	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	6317800051
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-09-14 12:43:22.890045	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.25.1	\N	\N	6317800051
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-09-14 12:43:22.89888	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.25.1	\N	\N	6317800051
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-09-14 12:43:22.903785	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.25.1	\N	\N	6317800051
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-09-14 12:43:22.905681	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.25.1	\N	\N	6317800051
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-09-14 12:43:22.934468	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.25.1	\N	\N	6317800051
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-09-14 12:43:22.936669	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.25.1	\N	\N	6317800051
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-09-14 12:43:22.944741	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.25.1	\N	\N	6317800051
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-09-14 12:43:22.946382	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	6317800051
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-09-14 12:43:22.951564	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	6317800051
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-09-14 12:43:22.953285	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	6317800051
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-09-14 12:43:22.960295	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	6317800051
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2024-09-14 12:43:22.967851	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.25.1	\N	\N	6317800051
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-09-14 12:43:22.982113	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.25.1	\N	\N	6317800051
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-09-14 12:43:22.993171	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.25.1	\N	\N	6317800051
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.004491	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.25.1	\N	\N	6317800051
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.017074	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.25.1	\N	\N	6317800051
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.025051	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.041839	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.25.1	\N	\N	6317800051
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.043862	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	6317800051
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.05812	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	6317800051
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.060201	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.25.1	\N	\N	6317800051
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-09-14 12:43:23.069053	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.25.1	\N	\N	6317800051
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.081504	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.083663	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.099848	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.109371	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.111795	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.120157	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.25.1	\N	\N	6317800051
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-09-14 12:43:23.130945	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.25.1	\N	\N	6317800051
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2024-09-14 12:43:23.139523	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.25.1	\N	\N	6317800051
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2024-09-14 12:43:23.146687	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.25.1	\N	\N	6317800051
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2024-09-14 12:43:23.153186	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.25.1	\N	\N	6317800051
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2024-09-14 12:43:23.167435	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.25.1	\N	\N	6317800051
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2024-09-14 12:43:23.176399	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.25.1	\N	\N	6317800051
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-09-14 12:43:23.183292	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	6317800051
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-09-14 12:43:23.185242	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	6317800051
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-09-14 12:43:23.194959	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2024-09-14 12:43:23.204708	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.25.1	\N	\N	6317800051
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-09-14 12:43:23.239411	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	6317800051
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-09-14 12:43:23.242782	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.25.1	\N	\N	6317800051
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-09-14 12:43:23.252558	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.25.1	\N	\N	6317800051
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-09-14 12:43:23.254587	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.25.1	\N	\N	6317800051
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-09-14 12:43:23.262943	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.25.1	\N	\N	6317800051
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-09-14 12:43:23.267376	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	6317800051
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-09-14 12:43:23.287819	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.25.1	\N	\N	6317800051
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-09-14 12:43:23.296861	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.25.1	\N	\N	6317800051
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-09-14 12:43:23.304822	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2024-09-14 12:43:23.313072	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2024-09-14 12:43:23.320799	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.25.1	\N	\N	6317800051
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2024-09-14 12:43:23.322413	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2024-09-14 12:43:23.324551	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	6317800051
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.331245	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.25.1	\N	\N	6317800051
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.337914	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
25.0.0-28265-index-cleanup	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.345927	128	EXECUTED	9:8c0cfa341a0474385b324f5c4b2dfcc1	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION; dropIndex ...		\N	4.25.1	\N	\N	6317800051
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.348398	129	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.356162	130	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	6317800051
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.383074	131	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.25.1	\N	\N	6317800051
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.400951	132	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.25.1	\N	\N	6317800051
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.403089	133	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.25.1	\N	\N	6317800051
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2024-09-14 12:43:23.413609	134	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.25.1	\N	\N	6317800051
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
54f3ea06-8843-40e5-b3eb-be7e36221acb	9a724b01-3203-4cce-bb10-3a9906087bcd	f
54f3ea06-8843-40e5-b3eb-be7e36221acb	6294c8fa-95e5-42f5-8b45-5a196344e1fa	t
54f3ea06-8843-40e5-b3eb-be7e36221acb	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512	t
54f3ea06-8843-40e5-b3eb-be7e36221acb	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5	t
54f3ea06-8843-40e5-b3eb-be7e36221acb	b9371a26-352d-4467-9d38-01aa81dc29a2	f
54f3ea06-8843-40e5-b3eb-be7e36221acb	ea7e17a4-b6ac-478f-b7a1-f1261629fafb	f
54f3ea06-8843-40e5-b3eb-be7e36221acb	06112d62-6860-4127-b75b-62969292df52	t
54f3ea06-8843-40e5-b3eb-be7e36221acb	4aa77aa5-671c-4088-97cc-851999012be7	t
54f3ea06-8843-40e5-b3eb-be7e36221acb	9aff924a-e12d-434c-95ca-9c8b4787d1ff	f
54f3ea06-8843-40e5-b3eb-be7e36221acb	520dab19-2b7f-4aeb-b74e-df9953057b57	t
54f3ea06-8843-40e5-b3eb-be7e36221acb	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	98980e62-59c7-4263-8eaf-d247f31fa096	f
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	e7bce410-4612-45ed-8bc8-71f8b5ea5ba1	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	0b39130e-8344-443a-a056-6847466aeb84	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	004c1da0-580d-4c27-bc3b-ccaac887836b	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	fdc55342-8c8f-443b-82bd-b247fef073cf	f
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	90649879-c0b5-43db-895e-704a0be0026b	f
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	09b3d3f2-3043-4971-b195-a289348e772b	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	600aaf34-ed49-403f-a5b5-11af5f66006f	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	db6feb21-f3a2-45c9-b8d1-091b83900c6c	f
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	37523f14-c9c0-40e2-9849-6e43373267d9	t
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	9cfc1f19-81ce-4f04-8159-8c468440ca23	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
587b2229-82a3-4623-b95e-38f548cca93c	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	${role_default-roles}	default-roles-master	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	\N
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	${role_admin}	admin	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	\N
a970e4ff-25b3-4a8e-8b98-126bec650869	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	${role_create-realm}	create-realm	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	\N
583525be-1dd8-4b74-a628-de638dca486b	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_create-client}	create-client	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
f70b6af0-9068-4681-ac3f-6271ecee1f20	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_view-realm}	view-realm	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
3b61530c-a479-4816-b4c1-0c8e83e0bf88	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_view-users}	view-users	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
89851a5c-040f-4826-80da-7eba4eacaae8	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_view-clients}	view-clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
baf86233-f857-4d86-8201-a02adc337c79	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_view-events}	view-events	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
2935502f-83ea-45be-ad82-388d0611b8c9	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_view-identity-providers}	view-identity-providers	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
bd81bdae-fc80-4a6e-b7e7-cbd683a5f459	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_view-authorization}	view-authorization	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
bae6c163-e0dc-4614-9925-7aa148122e09	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_manage-realm}	manage-realm	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
b29279d2-4759-445f-9d17-86cb9d19d4a3	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_manage-users}	manage-users	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
84830ac9-47bd-4f4a-a762-ca751c3c07ab	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_manage-clients}	manage-clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
ff884416-8f83-4784-8fa4-c89e3dd9b5f1	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_manage-events}	manage-events	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
1fef15df-1538-45ed-a74d-2ea10bc7824b	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_manage-identity-providers}	manage-identity-providers	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
82f3e9f0-5f1d-49b7-8ab7-d6a6177de161	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_manage-authorization}	manage-authorization	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
00784c1f-c60e-4a97-83a3-a90cabc6d136	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_query-users}	query-users	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
5929753d-0f91-4386-9fe3-3b970d4cb18d	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_query-clients}	query-clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
d86682f2-25ab-458a-88f9-0a7ded135406	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_query-realms}	query-realms	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
054fccd6-a62e-4b44-bf3b-d1ff03ac2b27	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_query-groups}	query-groups	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
3e16eab4-928b-4d51-b530-51933394a1a9	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_view-profile}	view-profile	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
5e619651-6834-4cb8-be40-74beca98c6ed	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_manage-account}	manage-account	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
8ff2a79e-f9b3-4cd0-856d-9f2af412d0fe	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_manage-account-links}	manage-account-links	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
2a6a2ac1-1053-4133-8275-eca2e5634e3c	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_view-applications}	view-applications	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
83c8181f-323d-49c2-9a22-ad98e46f8cb1	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_view-consent}	view-consent	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
bb56fbb5-edf5-4bea-9ef3-679dde1f4bfe	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_manage-consent}	manage-consent	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
67518ef7-dc26-413b-8de4-83ca8c0b4acb	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_view-groups}	view-groups	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
b74e9be5-e5ee-4b43-baef-72b58551c439	fe643097-576a-4604-bf5f-de842a33cc31	t	${role_delete-account}	delete-account	54f3ea06-8843-40e5-b3eb-be7e36221acb	fe643097-576a-4604-bf5f-de842a33cc31	\N
68aaf743-bbbb-45c8-bfbc-8681e51b356d	a6fad9c7-8475-49b0-91c9-be60736ac6ec	t	${role_read-token}	read-token	54f3ea06-8843-40e5-b3eb-be7e36221acb	a6fad9c7-8475-49b0-91c9-be60736ac6ec	\N
a4d892a4-bca3-4abc-99db-1eaa93ea72d3	caf4db36-734a-456b-89dd-d093baa1450b	t	${role_impersonation}	impersonation	54f3ea06-8843-40e5-b3eb-be7e36221acb	caf4db36-734a-456b-89dd-d093baa1450b	\N
01d4ec97-99ae-4b0c-be2d-87b1db405eba	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	${role_offline-access}	offline_access	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	\N
4a78f328-2a71-4e08-a65f-d1e085edfb15	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	${role_uma_authorization}	uma_authorization	54f3ea06-8843-40e5-b3eb-be7e36221acb	\N	\N
26b73ed3-d707-4d6d-858c-905be5d4d375	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f	${role_default-roles}	default-roles-external	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N	\N
0d0f7ba7-530b-49bb-81a5-786f7da6b54b	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_create-client}	create-client	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
0ce2a441-ff47-4ff7-b044-e4b12b91e325	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_view-realm}	view-realm	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
53e75358-bdd4-4cec-9279-894324efcdcb	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_view-users}	view-users	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
1e651586-b6c5-4b18-ab3a-57e2d6c73cf4	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_view-clients}	view-clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
379d7cc7-2666-470e-9667-d3c69990328c	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_view-events}	view-events	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
b5e37726-b902-47fa-8347-993ecd17db43	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_view-identity-providers}	view-identity-providers	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
e21ab6b9-9c5a-4d1a-a166-f2206d95a871	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_view-authorization}	view-authorization	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
3711e43c-bc39-4af0-b8f5-60a9ebdc3ee0	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_manage-realm}	manage-realm	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
9f385631-1576-49e2-bd38-46f179e1e919	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_manage-users}	manage-users	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
6e98eb80-9de0-47c2-ad27-b219c77df833	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_manage-clients}	manage-clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
15a99b7c-096c-41bb-95c2-00019376efed	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_manage-events}	manage-events	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
23f8660c-b9f4-4f29-81a8-062fb5d3c6ac	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_manage-identity-providers}	manage-identity-providers	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
da5c70f1-afae-4edd-a324-561295543f93	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_manage-authorization}	manage-authorization	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
2b6b7e72-75a9-4197-902c-2a01f4e69ff1	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_query-users}	query-users	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
5e6fb253-00b3-44ed-8af7-7a219ab7dcb3	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_query-clients}	query-clients	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
31667125-25da-4862-a2ec-92813aa74c68	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_query-realms}	query-realms	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
c706463d-d080-43e9-a5be-5b2aec1cf097	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_query-groups}	query-groups	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
8dc4d997-db13-4766-9804-0a7aedf6de64	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_realm-admin}	realm-admin	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
03efef7a-f8d3-42bd-b083-63a6a606c2b0	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_create-client}	create-client	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
89ea05e4-42aa-4f32-8d57-b8c84b5b658c	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_view-realm}	view-realm	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
794fc65d-d801-4c10-b116-b4d0c34137c7	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_view-users}	view-users	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
65b38f88-0e4c-4b71-8afb-766b40dada42	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_view-clients}	view-clients	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
21a53032-3ea0-460c-b645-7fe741ecc4fc	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_view-events}	view-events	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
676656fb-0bb6-4ae8-add3-fc89ff4fc984	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_view-identity-providers}	view-identity-providers	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
b7bf644f-1592-4e57-94e6-52844f328b8c	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_view-authorization}	view-authorization	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
c9c2ded5-c8b9-4603-a8c7-7543922488f9	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_manage-realm}	manage-realm	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
2ad02993-f469-416c-94f8-bff031d48bb8	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_manage-users}	manage-users	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
69d1d216-50bd-4e3d-80a8-7b5aee9f6a7d	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_manage-clients}	manage-clients	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
292ff663-8324-441c-bd31-7b4f848cfbcf	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_manage-events}	manage-events	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
2f42cb4a-f5eb-47b9-967d-9580d8a8290e	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_manage-identity-providers}	manage-identity-providers	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
500d7197-b7be-4506-bf05-7d0bafb44b51	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_manage-authorization}	manage-authorization	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
fec0458f-4d86-4d5c-b842-db6c3340fc8c	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_query-users}	query-users	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
2e80d874-da3b-480f-8399-00c0a9ca299d	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_query-clients}	query-clients	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
466b8dc0-fd26-4eb9-9bae-7997608fce80	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_query-realms}	query-realms	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
444dfaf6-cdf2-4be3-87ac-a42da7486506	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_query-groups}	query-groups	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
372c3eaf-bad2-4ab4-94dc-4d5690351fae	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_view-profile}	view-profile	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
048a7b32-c773-4dbd-a3ca-95e3340e194a	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_manage-account}	manage-account	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
f6f5c408-57db-4cc0-af4e-63b2de9ed4bc	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_manage-account-links}	manage-account-links	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
a28882ce-d09f-4897-879b-95b5ac646291	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_view-applications}	view-applications	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
3d4308e1-ad69-4d54-a678-6802a82b8b4c	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_view-consent}	view-consent	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
d31f1f07-deb9-44f8-ba93-233c0f40f466	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_manage-consent}	manage-consent	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
1f5e72c3-cd07-477b-8b35-e153733630a7	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_view-groups}	view-groups	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
3997f9fe-85fc-41a3-9c90-04f91bcacad7	132dc426-0436-4e8b-8ea1-6e64ff9432d0	t	${role_delete-account}	delete-account	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	132dc426-0436-4e8b-8ea1-6e64ff9432d0	\N
15130fd3-fdfd-470d-a780-5b5d72ba9e3d	6eec7586-daea-481d-b5b7-f9a206131fc5	t	${role_impersonation}	impersonation	54f3ea06-8843-40e5-b3eb-be7e36221acb	6eec7586-daea-481d-b5b7-f9a206131fc5	\N
9967fea2-2fb0-4f1a-8d17-1aae98fcbaee	f89bc995-b3f9-44e1-96b1-c9725e42f424	t	${role_impersonation}	impersonation	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f89bc995-b3f9-44e1-96b1-c9725e42f424	\N
b25eca0d-8b2e-4e62-ab2b-75569a8faec9	0728eec4-be95-424c-bcc2-af168326f808	t	${role_read-token}	read-token	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	0728eec4-be95-424c-bcc2-af168326f808	\N
31c16703-1b3f-491f-8f2f-2023cef5b15b	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f	${role_offline-access}	offline_access	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N	\N
cf5b9baa-0c15-49d2-b9f5-edfd462dcc8d	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f	${role_uma_authorization}	uma_authorization	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.migration_model (id, version, update_time) FROM stdin;
dp59i	25.0.5	1726317804
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.org (id, enabled, realm_id, group_id, name, description) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
6056ac6c-bb20-47c1-80b3-82749687a883	audience resolve	openid-connect	oidc-audience-resolve-mapper	23461f57-66b4-4ec3-bb77-9a8163c79075	\N
d18be944-19df-4161-b8c9-e3b2c89a1fe0	locale	openid-connect	oidc-usermodel-attribute-mapper	a145efeb-53a4-4adb-9420-cc3a6d59354d	\N
55fb7dcf-1e47-43b0-b7cb-8aec848540da	role list	saml	saml-role-list-mapper	\N	6294c8fa-95e5-42f5-8b45-5a196344e1fa
4679dda7-5745-4a23-b2af-937733e18ad7	full name	openid-connect	oidc-full-name-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
b9c6d04c-8976-4bf6-8017-a5eda69308fc	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
674bc8dd-827a-44d6-957c-0913265a3c3b	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
e7ad33be-d3a4-470f-ba10-1dffedd159f0	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
320de558-d607-422e-918f-338898ad6788	username	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
e653df5d-2841-4c32-9dee-014edba27a96	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
7f675647-e963-4c49-af3d-afb1694adb92	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
817a09de-9371-4ddc-893e-1ff127948d4e	website	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
62e39d6c-5820-4476-957b-174de75724e4	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
a03633e1-db46-4939-bc92-23fbbaa1b82f	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
8ebb927a-8f37-4519-aba2-1bb9190d5e90	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	b3883f08-3f2b-4ef7-aa3e-eac0bd61e512
00d87ab0-d206-44a1-9c8b-eecc76d6a974	email	openid-connect	oidc-usermodel-attribute-mapper	\N	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5
c9503bef-c774-4285-91d1-8d7192e1d5df	email verified	openid-connect	oidc-usermodel-property-mapper	\N	98a9b9d0-3fbf-497e-b0ec-391e70e08fc5
978e2dcc-0782-4f2b-acee-13b4474bd004	address	openid-connect	oidc-address-mapper	\N	b9371a26-352d-4467-9d38-01aa81dc29a2
2076bc46-cb44-4c41-b68d-778fded5eefe	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	ea7e17a4-b6ac-478f-b7a1-f1261629fafb
18808bc6-c282-4580-9036-ce42a15600c7	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	ea7e17a4-b6ac-478f-b7a1-f1261629fafb
9a61574a-b13a-45f1-b203-b0fb19a374cc	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	06112d62-6860-4127-b75b-62969292df52
888bbc20-6aca-4d18-80cb-6fe2733fe628	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	06112d62-6860-4127-b75b-62969292df52
a572fd07-afda-4553-8be1-2de47e5d44e7	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	06112d62-6860-4127-b75b-62969292df52
28f274fe-a1d7-49a6-9a5d-e9c20824091a	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	4aa77aa5-671c-4088-97cc-851999012be7
b327b1c4-ea75-44a7-b609-6157c24b263c	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	9aff924a-e12d-434c-95ca-9c8b4787d1ff
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	9aff924a-e12d-434c-95ca-9c8b4787d1ff
9d4b57da-e2f8-49ec-9275-82a6bc74ee6c	acr loa level	openid-connect	oidc-acr-mapper	\N	520dab19-2b7f-4aeb-b74e-df9953057b57
79ea0577-58a3-43e0-a67d-7a13da9a485f	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5
c6ffd9ca-f919-4ddf-b604-88f6b1ca7743	sub	openid-connect	oidc-sub-mapper	\N	0855bbcb-4dd4-4e7b-a1df-7e796a63c6c5
76bd7ad6-c084-4a99-826b-5dd7a8a9833a	audience resolve	openid-connect	oidc-audience-resolve-mapper	237dc447-55be-4469-bbcd-39dd7f9f4d17	\N
bcd4a3ef-9d8b-4ce0-a435-659db87146e6	role list	saml	saml-role-list-mapper	\N	e7bce410-4612-45ed-8bc8-71f8b5ea5ba1
284d6006-10e4-4de6-9a3a-58f95f702596	full name	openid-connect	oidc-full-name-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
902a36df-31ac-4284-8193-17a28a202b14	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
97ae7e78-fa15-4d35-8069-6636c6104c2c	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
600885f8-ffab-45f3-b333-21bfaf25afbc	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
79846c5e-a51c-4191-b474-ddaa8be0e12b	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	username	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
2a4f270f-f549-48d4-b915-a2cba8cfaf53	website	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
ba815052-a508-4713-8d09-86da220eee39	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
d21e0051-9a77-4af7-830b-f2ccd047680f	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
72c798e3-1afc-41f7-bd79-b113447466be	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
0682e2e4-4174-4330-85fa-6404d1f4b7e9	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	0b39130e-8344-443a-a056-6847466aeb84
8301f0b0-7766-404d-b8da-6b06e687aa70	email	openid-connect	oidc-usermodel-attribute-mapper	\N	004c1da0-580d-4c27-bc3b-ccaac887836b
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	email verified	openid-connect	oidc-usermodel-property-mapper	\N	004c1da0-580d-4c27-bc3b-ccaac887836b
7980b2cb-2b06-43bf-8dce-4c36533420da	address	openid-connect	oidc-address-mapper	\N	fdc55342-8c8f-443b-82bd-b247fef073cf
edd9030a-50c0-4142-9cd0-7c448c2cd50b	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	90649879-c0b5-43db-895e-704a0be0026b
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	90649879-c0b5-43db-895e-704a0be0026b
0913a86c-6f36-41dc-b60a-972937850e99	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	09b3d3f2-3043-4971-b195-a289348e772b
78365be0-c317-4c22-b80c-053237bc4eb3	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	09b3d3f2-3043-4971-b195-a289348e772b
f9f492e1-e44d-40f3-8347-7dbfd05bbdf9	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	09b3d3f2-3043-4971-b195-a289348e772b
e146da59-4a85-41d2-950b-87e7fd22ddbe	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	600aaf34-ed49-403f-a5b5-11af5f66006f
bc35950f-f892-4922-8cf0-d99a29f72e7d	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	db6feb21-f3a2-45c9-b8d1-091b83900c6c
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	db6feb21-f3a2-45c9-b8d1-091b83900c6c
a1b668b5-ce02-40b9-a211-e4a0d80cb13e	acr loa level	openid-connect	oidc-acr-mapper	\N	37523f14-c9c0-40e2-9849-6e43373267d9
a4f6b020-2201-4980-8977-084606446cc5	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	9cfc1f19-81ce-4f04-8159-8c468440ca23
3ff9873d-50b7-45a7-9946-6f9ac02400cc	sub	openid-connect	oidc-sub-mapper	\N	9cfc1f19-81ce-4f04-8159-8c468440ca23
8af4dc34-6997-44d3-a78d-665ad2f905e3	locale	openid-connect	oidc-usermodel-attribute-mapper	7c86823f-cc1a-43d0-ae29-6e82a14c1256	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
d18be944-19df-4161-b8c9-e3b2c89a1fe0	true	introspection.token.claim
d18be944-19df-4161-b8c9-e3b2c89a1fe0	true	userinfo.token.claim
d18be944-19df-4161-b8c9-e3b2c89a1fe0	locale	user.attribute
d18be944-19df-4161-b8c9-e3b2c89a1fe0	true	id.token.claim
d18be944-19df-4161-b8c9-e3b2c89a1fe0	true	access.token.claim
d18be944-19df-4161-b8c9-e3b2c89a1fe0	locale	claim.name
d18be944-19df-4161-b8c9-e3b2c89a1fe0	String	jsonType.label
55fb7dcf-1e47-43b0-b7cb-8aec848540da	false	single
55fb7dcf-1e47-43b0-b7cb-8aec848540da	Basic	attribute.nameformat
55fb7dcf-1e47-43b0-b7cb-8aec848540da	Role	attribute.name
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	true	introspection.token.claim
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	true	userinfo.token.claim
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	updatedAt	user.attribute
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	true	id.token.claim
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	true	access.token.claim
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	updated_at	claim.name
190cbf5f-ac26-4e86-9b2f-60af99b5cb8d	long	jsonType.label
320de558-d607-422e-918f-338898ad6788	true	introspection.token.claim
320de558-d607-422e-918f-338898ad6788	true	userinfo.token.claim
320de558-d607-422e-918f-338898ad6788	username	user.attribute
320de558-d607-422e-918f-338898ad6788	true	id.token.claim
320de558-d607-422e-918f-338898ad6788	true	access.token.claim
320de558-d607-422e-918f-338898ad6788	preferred_username	claim.name
320de558-d607-422e-918f-338898ad6788	String	jsonType.label
4679dda7-5745-4a23-b2af-937733e18ad7	true	introspection.token.claim
4679dda7-5745-4a23-b2af-937733e18ad7	true	userinfo.token.claim
4679dda7-5745-4a23-b2af-937733e18ad7	true	id.token.claim
4679dda7-5745-4a23-b2af-937733e18ad7	true	access.token.claim
62e39d6c-5820-4476-957b-174de75724e4	true	introspection.token.claim
62e39d6c-5820-4476-957b-174de75724e4	true	userinfo.token.claim
62e39d6c-5820-4476-957b-174de75724e4	gender	user.attribute
62e39d6c-5820-4476-957b-174de75724e4	true	id.token.claim
62e39d6c-5820-4476-957b-174de75724e4	true	access.token.claim
62e39d6c-5820-4476-957b-174de75724e4	gender	claim.name
62e39d6c-5820-4476-957b-174de75724e4	String	jsonType.label
674bc8dd-827a-44d6-957c-0913265a3c3b	true	introspection.token.claim
674bc8dd-827a-44d6-957c-0913265a3c3b	true	userinfo.token.claim
674bc8dd-827a-44d6-957c-0913265a3c3b	firstName	user.attribute
674bc8dd-827a-44d6-957c-0913265a3c3b	true	id.token.claim
674bc8dd-827a-44d6-957c-0913265a3c3b	true	access.token.claim
674bc8dd-827a-44d6-957c-0913265a3c3b	given_name	claim.name
674bc8dd-827a-44d6-957c-0913265a3c3b	String	jsonType.label
7f675647-e963-4c49-af3d-afb1694adb92	true	introspection.token.claim
7f675647-e963-4c49-af3d-afb1694adb92	true	userinfo.token.claim
7f675647-e963-4c49-af3d-afb1694adb92	picture	user.attribute
7f675647-e963-4c49-af3d-afb1694adb92	true	id.token.claim
7f675647-e963-4c49-af3d-afb1694adb92	true	access.token.claim
7f675647-e963-4c49-af3d-afb1694adb92	picture	claim.name
7f675647-e963-4c49-af3d-afb1694adb92	String	jsonType.label
817a09de-9371-4ddc-893e-1ff127948d4e	true	introspection.token.claim
817a09de-9371-4ddc-893e-1ff127948d4e	true	userinfo.token.claim
817a09de-9371-4ddc-893e-1ff127948d4e	website	user.attribute
817a09de-9371-4ddc-893e-1ff127948d4e	true	id.token.claim
817a09de-9371-4ddc-893e-1ff127948d4e	true	access.token.claim
817a09de-9371-4ddc-893e-1ff127948d4e	website	claim.name
817a09de-9371-4ddc-893e-1ff127948d4e	String	jsonType.label
8ebb927a-8f37-4519-aba2-1bb9190d5e90	true	introspection.token.claim
8ebb927a-8f37-4519-aba2-1bb9190d5e90	true	userinfo.token.claim
8ebb927a-8f37-4519-aba2-1bb9190d5e90	zoneinfo	user.attribute
8ebb927a-8f37-4519-aba2-1bb9190d5e90	true	id.token.claim
8ebb927a-8f37-4519-aba2-1bb9190d5e90	true	access.token.claim
8ebb927a-8f37-4519-aba2-1bb9190d5e90	zoneinfo	claim.name
8ebb927a-8f37-4519-aba2-1bb9190d5e90	String	jsonType.label
a03633e1-db46-4939-bc92-23fbbaa1b82f	true	introspection.token.claim
a03633e1-db46-4939-bc92-23fbbaa1b82f	true	userinfo.token.claim
a03633e1-db46-4939-bc92-23fbbaa1b82f	birthdate	user.attribute
a03633e1-db46-4939-bc92-23fbbaa1b82f	true	id.token.claim
a03633e1-db46-4939-bc92-23fbbaa1b82f	true	access.token.claim
a03633e1-db46-4939-bc92-23fbbaa1b82f	birthdate	claim.name
a03633e1-db46-4939-bc92-23fbbaa1b82f	String	jsonType.label
b9c6d04c-8976-4bf6-8017-a5eda69308fc	true	introspection.token.claim
b9c6d04c-8976-4bf6-8017-a5eda69308fc	true	userinfo.token.claim
b9c6d04c-8976-4bf6-8017-a5eda69308fc	lastName	user.attribute
b9c6d04c-8976-4bf6-8017-a5eda69308fc	true	id.token.claim
b9c6d04c-8976-4bf6-8017-a5eda69308fc	true	access.token.claim
b9c6d04c-8976-4bf6-8017-a5eda69308fc	family_name	claim.name
b9c6d04c-8976-4bf6-8017-a5eda69308fc	String	jsonType.label
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	true	introspection.token.claim
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	true	userinfo.token.claim
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	locale	user.attribute
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	true	id.token.claim
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	true	access.token.claim
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	locale	claim.name
c35ea2ad-10fb-4dcb-b8da-d52317674c7a	String	jsonType.label
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	true	introspection.token.claim
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	true	userinfo.token.claim
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	nickname	user.attribute
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	true	id.token.claim
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	true	access.token.claim
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	nickname	claim.name
cc10cd19-25e1-4c68-aaba-a93c8a56eea9	String	jsonType.label
e653df5d-2841-4c32-9dee-014edba27a96	true	introspection.token.claim
e653df5d-2841-4c32-9dee-014edba27a96	true	userinfo.token.claim
e653df5d-2841-4c32-9dee-014edba27a96	profile	user.attribute
e653df5d-2841-4c32-9dee-014edba27a96	true	id.token.claim
e653df5d-2841-4c32-9dee-014edba27a96	true	access.token.claim
e653df5d-2841-4c32-9dee-014edba27a96	profile	claim.name
e653df5d-2841-4c32-9dee-014edba27a96	String	jsonType.label
e7ad33be-d3a4-470f-ba10-1dffedd159f0	true	introspection.token.claim
e7ad33be-d3a4-470f-ba10-1dffedd159f0	true	userinfo.token.claim
e7ad33be-d3a4-470f-ba10-1dffedd159f0	middleName	user.attribute
e7ad33be-d3a4-470f-ba10-1dffedd159f0	true	id.token.claim
e7ad33be-d3a4-470f-ba10-1dffedd159f0	true	access.token.claim
e7ad33be-d3a4-470f-ba10-1dffedd159f0	middle_name	claim.name
e7ad33be-d3a4-470f-ba10-1dffedd159f0	String	jsonType.label
00d87ab0-d206-44a1-9c8b-eecc76d6a974	true	introspection.token.claim
00d87ab0-d206-44a1-9c8b-eecc76d6a974	true	userinfo.token.claim
00d87ab0-d206-44a1-9c8b-eecc76d6a974	email	user.attribute
00d87ab0-d206-44a1-9c8b-eecc76d6a974	true	id.token.claim
00d87ab0-d206-44a1-9c8b-eecc76d6a974	true	access.token.claim
00d87ab0-d206-44a1-9c8b-eecc76d6a974	email	claim.name
00d87ab0-d206-44a1-9c8b-eecc76d6a974	String	jsonType.label
c9503bef-c774-4285-91d1-8d7192e1d5df	true	introspection.token.claim
c9503bef-c774-4285-91d1-8d7192e1d5df	true	userinfo.token.claim
c9503bef-c774-4285-91d1-8d7192e1d5df	emailVerified	user.attribute
c9503bef-c774-4285-91d1-8d7192e1d5df	true	id.token.claim
c9503bef-c774-4285-91d1-8d7192e1d5df	true	access.token.claim
c9503bef-c774-4285-91d1-8d7192e1d5df	email_verified	claim.name
c9503bef-c774-4285-91d1-8d7192e1d5df	boolean	jsonType.label
978e2dcc-0782-4f2b-acee-13b4474bd004	formatted	user.attribute.formatted
978e2dcc-0782-4f2b-acee-13b4474bd004	country	user.attribute.country
978e2dcc-0782-4f2b-acee-13b4474bd004	true	introspection.token.claim
978e2dcc-0782-4f2b-acee-13b4474bd004	postal_code	user.attribute.postal_code
978e2dcc-0782-4f2b-acee-13b4474bd004	true	userinfo.token.claim
978e2dcc-0782-4f2b-acee-13b4474bd004	street	user.attribute.street
978e2dcc-0782-4f2b-acee-13b4474bd004	true	id.token.claim
978e2dcc-0782-4f2b-acee-13b4474bd004	region	user.attribute.region
978e2dcc-0782-4f2b-acee-13b4474bd004	true	access.token.claim
978e2dcc-0782-4f2b-acee-13b4474bd004	locality	user.attribute.locality
18808bc6-c282-4580-9036-ce42a15600c7	true	introspection.token.claim
18808bc6-c282-4580-9036-ce42a15600c7	true	userinfo.token.claim
18808bc6-c282-4580-9036-ce42a15600c7	phoneNumberVerified	user.attribute
18808bc6-c282-4580-9036-ce42a15600c7	true	id.token.claim
18808bc6-c282-4580-9036-ce42a15600c7	true	access.token.claim
18808bc6-c282-4580-9036-ce42a15600c7	phone_number_verified	claim.name
18808bc6-c282-4580-9036-ce42a15600c7	boolean	jsonType.label
2076bc46-cb44-4c41-b68d-778fded5eefe	true	introspection.token.claim
2076bc46-cb44-4c41-b68d-778fded5eefe	true	userinfo.token.claim
2076bc46-cb44-4c41-b68d-778fded5eefe	phoneNumber	user.attribute
2076bc46-cb44-4c41-b68d-778fded5eefe	true	id.token.claim
2076bc46-cb44-4c41-b68d-778fded5eefe	true	access.token.claim
2076bc46-cb44-4c41-b68d-778fded5eefe	phone_number	claim.name
2076bc46-cb44-4c41-b68d-778fded5eefe	String	jsonType.label
888bbc20-6aca-4d18-80cb-6fe2733fe628	true	introspection.token.claim
888bbc20-6aca-4d18-80cb-6fe2733fe628	true	multivalued
888bbc20-6aca-4d18-80cb-6fe2733fe628	foo	user.attribute
888bbc20-6aca-4d18-80cb-6fe2733fe628	true	access.token.claim
888bbc20-6aca-4d18-80cb-6fe2733fe628	resource_access.${client_id}.roles	claim.name
888bbc20-6aca-4d18-80cb-6fe2733fe628	String	jsonType.label
9a61574a-b13a-45f1-b203-b0fb19a374cc	true	introspection.token.claim
9a61574a-b13a-45f1-b203-b0fb19a374cc	true	multivalued
9a61574a-b13a-45f1-b203-b0fb19a374cc	foo	user.attribute
9a61574a-b13a-45f1-b203-b0fb19a374cc	true	access.token.claim
9a61574a-b13a-45f1-b203-b0fb19a374cc	realm_access.roles	claim.name
9a61574a-b13a-45f1-b203-b0fb19a374cc	String	jsonType.label
a572fd07-afda-4553-8be1-2de47e5d44e7	true	introspection.token.claim
a572fd07-afda-4553-8be1-2de47e5d44e7	true	access.token.claim
28f274fe-a1d7-49a6-9a5d-e9c20824091a	true	introspection.token.claim
28f274fe-a1d7-49a6-9a5d-e9c20824091a	true	access.token.claim
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	true	introspection.token.claim
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	true	multivalued
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	foo	user.attribute
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	true	id.token.claim
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	true	access.token.claim
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	groups	claim.name
1e8d31bc-18aa-401e-aa84-42de01f0e3b2	String	jsonType.label
b327b1c4-ea75-44a7-b609-6157c24b263c	true	introspection.token.claim
b327b1c4-ea75-44a7-b609-6157c24b263c	true	userinfo.token.claim
b327b1c4-ea75-44a7-b609-6157c24b263c	username	user.attribute
b327b1c4-ea75-44a7-b609-6157c24b263c	true	id.token.claim
b327b1c4-ea75-44a7-b609-6157c24b263c	true	access.token.claim
b327b1c4-ea75-44a7-b609-6157c24b263c	upn	claim.name
b327b1c4-ea75-44a7-b609-6157c24b263c	String	jsonType.label
9d4b57da-e2f8-49ec-9275-82a6bc74ee6c	true	introspection.token.claim
9d4b57da-e2f8-49ec-9275-82a6bc74ee6c	true	id.token.claim
9d4b57da-e2f8-49ec-9275-82a6bc74ee6c	true	access.token.claim
79ea0577-58a3-43e0-a67d-7a13da9a485f	AUTH_TIME	user.session.note
79ea0577-58a3-43e0-a67d-7a13da9a485f	true	introspection.token.claim
79ea0577-58a3-43e0-a67d-7a13da9a485f	true	id.token.claim
79ea0577-58a3-43e0-a67d-7a13da9a485f	true	access.token.claim
79ea0577-58a3-43e0-a67d-7a13da9a485f	auth_time	claim.name
79ea0577-58a3-43e0-a67d-7a13da9a485f	long	jsonType.label
c6ffd9ca-f919-4ddf-b604-88f6b1ca7743	true	introspection.token.claim
c6ffd9ca-f919-4ddf-b604-88f6b1ca7743	true	access.token.claim
bcd4a3ef-9d8b-4ce0-a435-659db87146e6	false	single
bcd4a3ef-9d8b-4ce0-a435-659db87146e6	Basic	attribute.nameformat
bcd4a3ef-9d8b-4ce0-a435-659db87146e6	Role	attribute.name
0682e2e4-4174-4330-85fa-6404d1f4b7e9	true	introspection.token.claim
0682e2e4-4174-4330-85fa-6404d1f4b7e9	true	userinfo.token.claim
0682e2e4-4174-4330-85fa-6404d1f4b7e9	updatedAt	user.attribute
0682e2e4-4174-4330-85fa-6404d1f4b7e9	true	id.token.claim
0682e2e4-4174-4330-85fa-6404d1f4b7e9	true	access.token.claim
0682e2e4-4174-4330-85fa-6404d1f4b7e9	updated_at	claim.name
0682e2e4-4174-4330-85fa-6404d1f4b7e9	long	jsonType.label
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	true	introspection.token.claim
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	true	userinfo.token.claim
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	username	user.attribute
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	true	id.token.claim
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	true	access.token.claim
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	preferred_username	claim.name
0ae6b565-88a7-49f0-bb39-a1ba2d61c39c	String	jsonType.label
284d6006-10e4-4de6-9a3a-58f95f702596	true	introspection.token.claim
284d6006-10e4-4de6-9a3a-58f95f702596	true	userinfo.token.claim
284d6006-10e4-4de6-9a3a-58f95f702596	true	id.token.claim
284d6006-10e4-4de6-9a3a-58f95f702596	true	access.token.claim
2a4f270f-f549-48d4-b915-a2cba8cfaf53	true	introspection.token.claim
2a4f270f-f549-48d4-b915-a2cba8cfaf53	true	userinfo.token.claim
2a4f270f-f549-48d4-b915-a2cba8cfaf53	website	user.attribute
2a4f270f-f549-48d4-b915-a2cba8cfaf53	true	id.token.claim
2a4f270f-f549-48d4-b915-a2cba8cfaf53	true	access.token.claim
2a4f270f-f549-48d4-b915-a2cba8cfaf53	website	claim.name
2a4f270f-f549-48d4-b915-a2cba8cfaf53	String	jsonType.label
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	true	introspection.token.claim
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	true	userinfo.token.claim
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	profile	user.attribute
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	true	id.token.claim
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	true	access.token.claim
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	profile	claim.name
3e22e22f-32f4-4f59-a4ab-2f73dfd4b9e3	String	jsonType.label
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	true	introspection.token.claim
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	true	userinfo.token.claim
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	locale	user.attribute
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	true	id.token.claim
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	true	access.token.claim
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	locale	claim.name
58d13e01-3dcc-4ac5-ad73-6cef923b2fe7	String	jsonType.label
600885f8-ffab-45f3-b333-21bfaf25afbc	true	introspection.token.claim
600885f8-ffab-45f3-b333-21bfaf25afbc	true	userinfo.token.claim
600885f8-ffab-45f3-b333-21bfaf25afbc	middleName	user.attribute
600885f8-ffab-45f3-b333-21bfaf25afbc	true	id.token.claim
600885f8-ffab-45f3-b333-21bfaf25afbc	true	access.token.claim
600885f8-ffab-45f3-b333-21bfaf25afbc	middle_name	claim.name
600885f8-ffab-45f3-b333-21bfaf25afbc	String	jsonType.label
72c798e3-1afc-41f7-bd79-b113447466be	true	introspection.token.claim
72c798e3-1afc-41f7-bd79-b113447466be	true	userinfo.token.claim
72c798e3-1afc-41f7-bd79-b113447466be	zoneinfo	user.attribute
72c798e3-1afc-41f7-bd79-b113447466be	true	id.token.claim
72c798e3-1afc-41f7-bd79-b113447466be	true	access.token.claim
72c798e3-1afc-41f7-bd79-b113447466be	zoneinfo	claim.name
72c798e3-1afc-41f7-bd79-b113447466be	String	jsonType.label
79846c5e-a51c-4191-b474-ddaa8be0e12b	true	introspection.token.claim
79846c5e-a51c-4191-b474-ddaa8be0e12b	true	userinfo.token.claim
79846c5e-a51c-4191-b474-ddaa8be0e12b	nickname	user.attribute
79846c5e-a51c-4191-b474-ddaa8be0e12b	true	id.token.claim
79846c5e-a51c-4191-b474-ddaa8be0e12b	true	access.token.claim
79846c5e-a51c-4191-b474-ddaa8be0e12b	nickname	claim.name
79846c5e-a51c-4191-b474-ddaa8be0e12b	String	jsonType.label
902a36df-31ac-4284-8193-17a28a202b14	true	introspection.token.claim
902a36df-31ac-4284-8193-17a28a202b14	true	userinfo.token.claim
902a36df-31ac-4284-8193-17a28a202b14	lastName	user.attribute
902a36df-31ac-4284-8193-17a28a202b14	true	id.token.claim
902a36df-31ac-4284-8193-17a28a202b14	true	access.token.claim
902a36df-31ac-4284-8193-17a28a202b14	family_name	claim.name
902a36df-31ac-4284-8193-17a28a202b14	String	jsonType.label
97ae7e78-fa15-4d35-8069-6636c6104c2c	true	introspection.token.claim
97ae7e78-fa15-4d35-8069-6636c6104c2c	true	userinfo.token.claim
97ae7e78-fa15-4d35-8069-6636c6104c2c	firstName	user.attribute
97ae7e78-fa15-4d35-8069-6636c6104c2c	true	id.token.claim
97ae7e78-fa15-4d35-8069-6636c6104c2c	true	access.token.claim
97ae7e78-fa15-4d35-8069-6636c6104c2c	given_name	claim.name
97ae7e78-fa15-4d35-8069-6636c6104c2c	String	jsonType.label
ba815052-a508-4713-8d09-86da220eee39	true	introspection.token.claim
ba815052-a508-4713-8d09-86da220eee39	true	userinfo.token.claim
ba815052-a508-4713-8d09-86da220eee39	gender	user.attribute
ba815052-a508-4713-8d09-86da220eee39	true	id.token.claim
ba815052-a508-4713-8d09-86da220eee39	true	access.token.claim
ba815052-a508-4713-8d09-86da220eee39	gender	claim.name
ba815052-a508-4713-8d09-86da220eee39	String	jsonType.label
d21e0051-9a77-4af7-830b-f2ccd047680f	true	introspection.token.claim
d21e0051-9a77-4af7-830b-f2ccd047680f	true	userinfo.token.claim
d21e0051-9a77-4af7-830b-f2ccd047680f	birthdate	user.attribute
d21e0051-9a77-4af7-830b-f2ccd047680f	true	id.token.claim
d21e0051-9a77-4af7-830b-f2ccd047680f	true	access.token.claim
d21e0051-9a77-4af7-830b-f2ccd047680f	birthdate	claim.name
d21e0051-9a77-4af7-830b-f2ccd047680f	String	jsonType.label
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	true	introspection.token.claim
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	true	userinfo.token.claim
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	picture	user.attribute
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	true	id.token.claim
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	true	access.token.claim
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	picture	claim.name
eb3960b8-1719-4ee7-9195-ffad5fe7a64e	String	jsonType.label
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	true	introspection.token.claim
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	true	userinfo.token.claim
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	emailVerified	user.attribute
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	true	id.token.claim
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	true	access.token.claim
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	email_verified	claim.name
7f2b0ebc-33c0-45b1-bfb1-ecdabeed80d5	boolean	jsonType.label
8301f0b0-7766-404d-b8da-6b06e687aa70	true	introspection.token.claim
8301f0b0-7766-404d-b8da-6b06e687aa70	true	userinfo.token.claim
8301f0b0-7766-404d-b8da-6b06e687aa70	email	user.attribute
8301f0b0-7766-404d-b8da-6b06e687aa70	true	id.token.claim
8301f0b0-7766-404d-b8da-6b06e687aa70	true	access.token.claim
8301f0b0-7766-404d-b8da-6b06e687aa70	email	claim.name
8301f0b0-7766-404d-b8da-6b06e687aa70	String	jsonType.label
7980b2cb-2b06-43bf-8dce-4c36533420da	formatted	user.attribute.formatted
7980b2cb-2b06-43bf-8dce-4c36533420da	country	user.attribute.country
7980b2cb-2b06-43bf-8dce-4c36533420da	true	introspection.token.claim
7980b2cb-2b06-43bf-8dce-4c36533420da	postal_code	user.attribute.postal_code
7980b2cb-2b06-43bf-8dce-4c36533420da	true	userinfo.token.claim
7980b2cb-2b06-43bf-8dce-4c36533420da	street	user.attribute.street
7980b2cb-2b06-43bf-8dce-4c36533420da	true	id.token.claim
7980b2cb-2b06-43bf-8dce-4c36533420da	region	user.attribute.region
7980b2cb-2b06-43bf-8dce-4c36533420da	true	access.token.claim
7980b2cb-2b06-43bf-8dce-4c36533420da	locality	user.attribute.locality
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	true	introspection.token.claim
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	true	userinfo.token.claim
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	phoneNumberVerified	user.attribute
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	true	id.token.claim
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	true	access.token.claim
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	phone_number_verified	claim.name
4de4d1d4-fa31-4163-ad26-7d0de2bdb2c9	boolean	jsonType.label
edd9030a-50c0-4142-9cd0-7c448c2cd50b	true	introspection.token.claim
edd9030a-50c0-4142-9cd0-7c448c2cd50b	true	userinfo.token.claim
edd9030a-50c0-4142-9cd0-7c448c2cd50b	phoneNumber	user.attribute
edd9030a-50c0-4142-9cd0-7c448c2cd50b	true	id.token.claim
edd9030a-50c0-4142-9cd0-7c448c2cd50b	true	access.token.claim
edd9030a-50c0-4142-9cd0-7c448c2cd50b	phone_number	claim.name
edd9030a-50c0-4142-9cd0-7c448c2cd50b	String	jsonType.label
0913a86c-6f36-41dc-b60a-972937850e99	true	introspection.token.claim
0913a86c-6f36-41dc-b60a-972937850e99	true	multivalued
0913a86c-6f36-41dc-b60a-972937850e99	foo	user.attribute
0913a86c-6f36-41dc-b60a-972937850e99	true	access.token.claim
0913a86c-6f36-41dc-b60a-972937850e99	realm_access.roles	claim.name
0913a86c-6f36-41dc-b60a-972937850e99	String	jsonType.label
78365be0-c317-4c22-b80c-053237bc4eb3	true	introspection.token.claim
78365be0-c317-4c22-b80c-053237bc4eb3	true	multivalued
78365be0-c317-4c22-b80c-053237bc4eb3	foo	user.attribute
78365be0-c317-4c22-b80c-053237bc4eb3	true	access.token.claim
78365be0-c317-4c22-b80c-053237bc4eb3	resource_access.${client_id}.roles	claim.name
78365be0-c317-4c22-b80c-053237bc4eb3	String	jsonType.label
f9f492e1-e44d-40f3-8347-7dbfd05bbdf9	true	introspection.token.claim
f9f492e1-e44d-40f3-8347-7dbfd05bbdf9	true	access.token.claim
e146da59-4a85-41d2-950b-87e7fd22ddbe	true	introspection.token.claim
e146da59-4a85-41d2-950b-87e7fd22ddbe	true	access.token.claim
bc35950f-f892-4922-8cf0-d99a29f72e7d	true	introspection.token.claim
bc35950f-f892-4922-8cf0-d99a29f72e7d	true	userinfo.token.claim
bc35950f-f892-4922-8cf0-d99a29f72e7d	username	user.attribute
bc35950f-f892-4922-8cf0-d99a29f72e7d	true	id.token.claim
bc35950f-f892-4922-8cf0-d99a29f72e7d	true	access.token.claim
bc35950f-f892-4922-8cf0-d99a29f72e7d	upn	claim.name
bc35950f-f892-4922-8cf0-d99a29f72e7d	String	jsonType.label
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	true	introspection.token.claim
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	true	multivalued
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	foo	user.attribute
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	true	id.token.claim
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	true	access.token.claim
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	groups	claim.name
f7aa6ce7-53e5-42a8-a6fc-2a078526ff6e	String	jsonType.label
a1b668b5-ce02-40b9-a211-e4a0d80cb13e	true	introspection.token.claim
a1b668b5-ce02-40b9-a211-e4a0d80cb13e	true	id.token.claim
a1b668b5-ce02-40b9-a211-e4a0d80cb13e	true	access.token.claim
3ff9873d-50b7-45a7-9946-6f9ac02400cc	true	introspection.token.claim
3ff9873d-50b7-45a7-9946-6f9ac02400cc	true	access.token.claim
a4f6b020-2201-4980-8977-084606446cc5	AUTH_TIME	user.session.note
a4f6b020-2201-4980-8977-084606446cc5	true	introspection.token.claim
a4f6b020-2201-4980-8977-084606446cc5	true	id.token.claim
a4f6b020-2201-4980-8977-084606446cc5	true	access.token.claim
a4f6b020-2201-4980-8977-084606446cc5	auth_time	claim.name
a4f6b020-2201-4980-8977-084606446cc5	long	jsonType.label
8af4dc34-6997-44d3-a78d-665ad2f905e3	true	introspection.token.claim
8af4dc34-6997-44d3-a78d-665ad2f905e3	true	userinfo.token.claim
8af4dc34-6997-44d3-a78d-665ad2f905e3	locale	user.attribute
8af4dc34-6997-44d3-a78d-665ad2f905e3	true	id.token.claim
8af4dc34-6997-44d3-a78d-665ad2f905e3	true	access.token.claim
8af4dc34-6997-44d3-a78d-665ad2f905e3	locale	claim.name
8af4dc34-6997-44d3-a78d-665ad2f905e3	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
54f3ea06-8843-40e5-b3eb-be7e36221acb	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	caf4db36-734a-456b-89dd-d093baa1450b	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	e78b81e3-1014-4513-90d1-cd76de9d0f73	7aa347db-c872-4db6-929e-fea17d85a200	c299bd38-a263-4ee7-b5b2-48ae6dad3a94	0fdbd9a8-3063-4a5b-92e7-22cf2a72d938	46e861c8-c21a-4415-9bc0-193826ebb153	2592000	f	900	t	f	29218bdc-aab6-49cd-8853-05f87d348070	0	f	0	0	587b2229-82a3-4623-b95e-38f548cca93c
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	60	300	300	\N	\N	\N	t	f	0	\N	external	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	6eec7586-daea-481d-b5b7-f9a206131fc5	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	14f9cc2f-96d3-4bbb-a6fc-d800afed3bc8	9e645db6-7b14-418f-909c-5ef9889f6d99	1ffdebbb-ce1c-4e34-b061-52621653a523	dfec3aaa-6640-48a5-9847-1b1367597ed1	9fc7473d-e2f9-4c11-a44a-91fbaeb3d531	2592000	f	900	t	f	c8929114-ff35-42d8-aa6b-d05bea2a4c32	0	f	0	0	26b73ed3-d707-4d6d-858c-905be5d4d375
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	54f3ea06-8843-40e5-b3eb-be7e36221acb	
_browser_header.xContentTypeOptions	54f3ea06-8843-40e5-b3eb-be7e36221acb	nosniff
_browser_header.referrerPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	no-referrer
_browser_header.xRobotsTag	54f3ea06-8843-40e5-b3eb-be7e36221acb	none
_browser_header.xFrameOptions	54f3ea06-8843-40e5-b3eb-be7e36221acb	SAMEORIGIN
_browser_header.contentSecurityPolicy	54f3ea06-8843-40e5-b3eb-be7e36221acb	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	54f3ea06-8843-40e5-b3eb-be7e36221acb	1; mode=block
_browser_header.strictTransportSecurity	54f3ea06-8843-40e5-b3eb-be7e36221acb	max-age=31536000; includeSubDomains
bruteForceProtected	54f3ea06-8843-40e5-b3eb-be7e36221acb	false
permanentLockout	54f3ea06-8843-40e5-b3eb-be7e36221acb	false
maxTemporaryLockouts	54f3ea06-8843-40e5-b3eb-be7e36221acb	0
maxFailureWaitSeconds	54f3ea06-8843-40e5-b3eb-be7e36221acb	900
minimumQuickLoginWaitSeconds	54f3ea06-8843-40e5-b3eb-be7e36221acb	60
waitIncrementSeconds	54f3ea06-8843-40e5-b3eb-be7e36221acb	60
quickLoginCheckMilliSeconds	54f3ea06-8843-40e5-b3eb-be7e36221acb	1000
maxDeltaTimeSeconds	54f3ea06-8843-40e5-b3eb-be7e36221acb	43200
failureFactor	54f3ea06-8843-40e5-b3eb-be7e36221acb	30
realmReusableOtpCode	54f3ea06-8843-40e5-b3eb-be7e36221acb	false
firstBrokerLoginFlowId	54f3ea06-8843-40e5-b3eb-be7e36221acb	f6dcf37d-fb5c-4e0c-94ca-68c9f85bcd88
displayName	54f3ea06-8843-40e5-b3eb-be7e36221acb	Keycloak
displayNameHtml	54f3ea06-8843-40e5-b3eb-be7e36221acb	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	54f3ea06-8843-40e5-b3eb-be7e36221acb	RS256
offlineSessionMaxLifespanEnabled	54f3ea06-8843-40e5-b3eb-be7e36221acb	false
offlineSessionMaxLifespan	54f3ea06-8843-40e5-b3eb-be7e36221acb	5184000
_browser_header.contentSecurityPolicyReportOnly	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	
_browser_header.xContentTypeOptions	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	nosniff
_browser_header.referrerPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	no-referrer
_browser_header.xRobotsTag	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	none
_browser_header.xFrameOptions	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	SAMEORIGIN
_browser_header.contentSecurityPolicy	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	1; mode=block
_browser_header.strictTransportSecurity	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	max-age=31536000; includeSubDomains
bruteForceProtected	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	false
permanentLockout	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	false
maxTemporaryLockouts	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	0
maxFailureWaitSeconds	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	900
minimumQuickLoginWaitSeconds	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	60
waitIncrementSeconds	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	60
quickLoginCheckMilliSeconds	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	1000
maxDeltaTimeSeconds	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	43200
failureFactor	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	30
realmReusableOtpCode	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	false
defaultSignatureAlgorithm	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	RS256
offlineSessionMaxLifespanEnabled	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	false
offlineSessionMaxLifespan	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	5184000
actionTokenGeneratedByAdminLifespan	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	43200
actionTokenGeneratedByUserLifespan	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	300
oauth2DeviceCodeLifespan	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	600
oauth2DevicePollingInterval	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	5
webAuthnPolicyRpEntityName	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	keycloak
webAuthnPolicySignatureAlgorithms	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	ES256
webAuthnPolicyRpId	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	
webAuthnPolicyAttestationConveyancePreference	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyAuthenticatorAttachment	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyRequireResidentKey	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyUserVerificationRequirement	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyCreateTimeout	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	0
webAuthnPolicyAvoidSameAuthenticatorRegister	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	false
webAuthnPolicyRpEntityNamePasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	ES256
webAuthnPolicyRpIdPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	
webAuthnPolicyAttestationConveyancePreferencePasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyRequireResidentKeyPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	not specified
webAuthnPolicyCreateTimeoutPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	false
cibaBackchannelTokenDeliveryMode	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	poll
cibaExpiresIn	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	120
cibaInterval	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	5
cibaAuthRequestedUserHint	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	login_hint
parRequestUriLifespan	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	60
firstBrokerLoginFlowId	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	349f403b-1694-47f6-8d47-5a30da720a56
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
54f3ea06-8843-40e5-b3eb-be7e36221acb	jboss-logging
abd99bcc-2d33-4252-853a-bd2e74d3a9a5	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	54f3ea06-8843-40e5-b3eb-be7e36221acb
password	password	t	t	abd99bcc-2d33-4252-853a-bd2e74d3a9a5
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.redirect_uris (client_id, value) FROM stdin;
fe643097-576a-4604-bf5f-de842a33cc31	/realms/master/account/*
23461f57-66b4-4ec3-bb77-9a8163c79075	/realms/master/account/*
a145efeb-53a4-4adb-9420-cc3a6d59354d	/admin/master/console/*
132dc426-0436-4e8b-8ea1-6e64ff9432d0	/realms/external/account/*
237dc447-55be-4469-bbcd-39dd7f9f4d17	/realms/external/account/*
7c86823f-cc1a-43d0-ae29-6e82a14c1256	/admin/external/console/*
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	http://localhost:8081/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
2fb1c4a5-3df1-47cd-8f0c-6ec869f0a91c	VERIFY_EMAIL	Verify Email	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	VERIFY_EMAIL	50
acb4088f-51d6-405c-9a8e-1a9fb2e91beb	UPDATE_PROFILE	Update Profile	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	UPDATE_PROFILE	40
fea45571-4fb1-4565-9364-2b82c986c1b2	CONFIGURE_TOTP	Configure OTP	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	CONFIGURE_TOTP	10
76f06a76-f83c-4ddc-9b9a-98c3d2daa1cc	UPDATE_PASSWORD	Update Password	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	UPDATE_PASSWORD	30
17451030-ceab-4615-8ff4-7e6566c5d1ae	TERMS_AND_CONDITIONS	Terms and Conditions	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	f	TERMS_AND_CONDITIONS	20
2d97b4a4-bd86-4fc7-b2f7-1a24beeb4b9a	delete_account	Delete Account	54f3ea06-8843-40e5-b3eb-be7e36221acb	f	f	delete_account	60
7e7fc255-a962-4e7a-af91-22853d1403d5	delete_credential	Delete Credential	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	delete_credential	100
e7f60ca0-4085-4f40-86fc-039fa9acab78	update_user_locale	Update User Locale	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	update_user_locale	1000
02ac4998-c673-4275-86cb-a4df57dded12	webauthn-register	Webauthn Register	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	webauthn-register	70
794ce3f0-e590-4dce-b47c-aeb6b099a348	webauthn-register-passwordless	Webauthn Register Passwordless	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	webauthn-register-passwordless	80
2ebb6170-575c-4a9d-9f4a-16354c974fd8	VERIFY_PROFILE	Verify Profile	54f3ea06-8843-40e5-b3eb-be7e36221acb	t	f	VERIFY_PROFILE	90
716ea834-101b-400a-a27f-cc083e7e3481	VERIFY_EMAIL	Verify Email	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	VERIFY_EMAIL	50
515b2436-34bb-47d6-9708-889cc25994c2	UPDATE_PROFILE	Update Profile	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	UPDATE_PROFILE	40
b30ee491-e8bb-492d-a203-9757c02618b9	CONFIGURE_TOTP	Configure OTP	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	CONFIGURE_TOTP	10
c10cd82a-bb92-437e-a380-be8d266649af	UPDATE_PASSWORD	Update Password	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	UPDATE_PASSWORD	30
12515336-c744-4203-b12b-5a0ad1395dd3	TERMS_AND_CONDITIONS	Terms and Conditions	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f	f	TERMS_AND_CONDITIONS	20
5c09c8dd-b04d-4c32-b1e6-092560b61717	delete_account	Delete Account	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	f	f	delete_account	60
f5146e0f-6e3b-4f87-bb7a-6e72a3e9c90d	delete_credential	Delete Credential	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	delete_credential	100
b8400bbf-eb9d-4bc6-9f57-7812ed53f8a5	update_user_locale	Update User Locale	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	update_user_locale	1000
4c6ca11a-9e50-4864-a85a-d041e081be55	webauthn-register	Webauthn Register	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	webauthn-register	70
e51026a5-c64e-4c4f-b873-e12550bb3dfd	webauthn-register-passwordless	Webauthn Register Passwordless	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	webauthn-register-passwordless	80
3c20b49c-6c3b-400f-bb59-fed64b5f84f6	VERIFY_PROFILE	Verify Profile	abd99bcc-2d33-4252-853a-bd2e74d3a9a5	t	f	VERIFY_PROFILE	90
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
23461f57-66b4-4ec3-bb77-9a8163c79075	67518ef7-dc26-413b-8de4-83ca8c0b4acb
23461f57-66b4-4ec3-bb77-9a8163c79075	5e619651-6834-4cb8-be40-74beca98c6ed
237dc447-55be-4469-bbcd-39dd7f9f4d17	048a7b32-c773-4dbd-a3ca-95e3340e194a
237dc447-55be-4469-bbcd-39dd7f9f4d17	1f5e72c3-cd07-477b-8b35-e153733630a7
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
7938682c-2c82-4039-b7ce-b348607917df	\N	4ef91ff3-31c0-4499-99cd-dee226029deb	f	t	\N	\N	\N	54f3ea06-8843-40e5-b3eb-be7e36221acb	user	1726317807145	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
587b2229-82a3-4623-b95e-38f548cca93c	7938682c-2c82-4039-b7ce-b348607917df
73fa5929-53f0-4f43-9af4-fb6e3c7d6b08	7938682c-2c82-4039-b7ce-b348607917df
0d0f7ba7-530b-49bb-81a5-786f7da6b54b	7938682c-2c82-4039-b7ce-b348607917df
0ce2a441-ff47-4ff7-b044-e4b12b91e325	7938682c-2c82-4039-b7ce-b348607917df
53e75358-bdd4-4cec-9279-894324efcdcb	7938682c-2c82-4039-b7ce-b348607917df
1e651586-b6c5-4b18-ab3a-57e2d6c73cf4	7938682c-2c82-4039-b7ce-b348607917df
379d7cc7-2666-470e-9667-d3c69990328c	7938682c-2c82-4039-b7ce-b348607917df
b5e37726-b902-47fa-8347-993ecd17db43	7938682c-2c82-4039-b7ce-b348607917df
e21ab6b9-9c5a-4d1a-a166-f2206d95a871	7938682c-2c82-4039-b7ce-b348607917df
3711e43c-bc39-4af0-b8f5-60a9ebdc3ee0	7938682c-2c82-4039-b7ce-b348607917df
9f385631-1576-49e2-bd38-46f179e1e919	7938682c-2c82-4039-b7ce-b348607917df
6e98eb80-9de0-47c2-ad27-b219c77df833	7938682c-2c82-4039-b7ce-b348607917df
15a99b7c-096c-41bb-95c2-00019376efed	7938682c-2c82-4039-b7ce-b348607917df
23f8660c-b9f4-4f29-81a8-062fb5d3c6ac	7938682c-2c82-4039-b7ce-b348607917df
da5c70f1-afae-4edd-a324-561295543f93	7938682c-2c82-4039-b7ce-b348607917df
2b6b7e72-75a9-4197-902c-2a01f4e69ff1	7938682c-2c82-4039-b7ce-b348607917df
5e6fb253-00b3-44ed-8af7-7a219ab7dcb3	7938682c-2c82-4039-b7ce-b348607917df
31667125-25da-4862-a2ec-92813aa74c68	7938682c-2c82-4039-b7ce-b348607917df
c706463d-d080-43e9-a5be-5b2aec1cf097	7938682c-2c82-4039-b7ce-b348607917df
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.web_origins (client_id, value) FROM stdin;
a145efeb-53a4-4adb-9420-cc3a6d59354d	+
7c86823f-cc1a-43d0-ae29-6e82a14c1256	+
1a6f8d35-2cf9-4d23-8023-2f5ec46e4284	http://localhost:8081
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

