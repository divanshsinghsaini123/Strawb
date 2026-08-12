--
-- PostgreSQL database dump
--

\restrict w0CmFSg8LdAypyDNdqRATU6yclVW0ssFzt2F73mZ1ZzB68rKrM9fyX0QezGae39

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

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

--
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: strawb-user
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO "strawb-user";

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: strawb-user
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO "strawb-user";

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: strawb-user
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO "strawb-user";

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: strawb-user
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO "strawb-user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO "strawb-user";

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO "strawb-user";

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO "strawb-user";

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO "strawb-user";

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO "strawb-user";

--
-- Name: auth_mfa_factor; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.auth_mfa_factor (
    id text NOT NULL,
    auth_identity_id text NOT NULL,
    provider text NOT NULL,
    status text NOT NULL,
    provider_metadata jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_mfa_factor OWNER TO "strawb-user";

--
-- Name: auth_mfa_recovery_code; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.auth_mfa_recovery_code (
    id text NOT NULL,
    auth_identity_id text NOT NULL,
    code_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_mfa_recovery_code OWNER TO "strawb-user";

--
-- Name: auth_password_reset_token; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.auth_password_reset_token (
    id text NOT NULL,
    auth_identity_id text NOT NULL,
    provider_identity_id text NOT NULL,
    entity_id text NOT NULL,
    token_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_password_reset_token OWNER TO "strawb-user";

--
-- Name: auth_verification; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.auth_verification (
    id text NOT NULL,
    auth_identity_id text NOT NULL,
    entity_id text NOT NULL,
    entity_type text NOT NULL,
    code_provider text NOT NULL,
    verified_at timestamp with time zone,
    requested_at timestamp with time zone NOT NULL,
    provider_metadata jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_verification OWNER TO "strawb-user";

--
-- Name: capture; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO "strawb-user";

--
-- Name: cart; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    locale text
);


ALTER TABLE public.cart OWNER TO "strawb-user";

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO "strawb-user";

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO "strawb-user";

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO "strawb-user";

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    data jsonb
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO "strawb-user";

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO "strawb-user";

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO "strawb-user";

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO "strawb-user";

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO "strawb-user";

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text,
    data jsonb
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO "strawb-user";

--
-- Name: content_collection; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_collection (
    id text NOT NULL,
    label text NOT NULL,
    slug text NOT NULL,
    format text NOT NULL,
    prefix text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    searchable boolean DEFAULT false NOT NULL,
    CONSTRAINT content_collection_format_check CHECK ((format = ANY (ARRAY['html'::text, 'img'::text, 'json'::text, 'md'::text, 'text'::text])))
);


ALTER TABLE public.content_collection OWNER TO "strawb-user";

--
-- Name: content_creator; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_creator (
    id text NOT NULL,
    name text NOT NULL,
    bio text,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.content_creator OWNER TO "strawb-user";

--
-- Name: content_creator_activity; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_creator_activity (
    id text NOT NULL,
    type text DEFAULT 'note'::text NOT NULL,
    user_id text NOT NULL,
    note text,
    metadata jsonb,
    creator_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT content_creator_activity_type_check CHECK ((type = ANY (ARRAY['edit'::text, 'note'::text])))
);


ALTER TABLE public.content_creator_activity OWNER TO "strawb-user";

--
-- Name: content_field; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_field (
    id text NOT NULL,
    name text NOT NULL,
    label text NOT NULL,
    field_type text NOT NULL,
    required boolean DEFAULT false NOT NULL,
    options jsonb,
    default_value jsonb,
    sort_order integer DEFAULT 0 NOT NULL,
    content_collection_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.content_field OWNER TO "strawb-user";

--
-- Name: content_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_item (
    id text NOT NULL,
    title text NOT NULL,
    slug text NOT NULL,
    body text,
    status text DEFAULT 'draft'::text NOT NULL,
    published_at timestamp with time zone,
    metadata jsonb,
    content_collection_id text NOT NULL,
    creator_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT content_item_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'archived'::text])))
);


ALTER TABLE public.content_item OWNER TO "strawb-user";

--
-- Name: content_item_activity; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_item_activity (
    id text NOT NULL,
    type text DEFAULT 'note'::text NOT NULL,
    user_id text NOT NULL,
    note text,
    metadata jsonb,
    item_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT content_item_activity_type_check CHECK ((type = ANY (ARRAY['publish'::text, 'archive'::text, 'draft'::text, 'edit'::text, 'note'::text])))
);


ALTER TABLE public.content_item_activity OWNER TO "strawb-user";

--
-- Name: content_link; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_link (
    id text NOT NULL,
    source_item_id text NOT NULL,
    target_item_id text NOT NULL,
    relationship_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.content_link OWNER TO "strawb-user";

--
-- Name: content_relationship; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_relationship (
    id text NOT NULL,
    relationship_type text NOT NULL,
    source_collection_id text NOT NULL,
    target_collection_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT content_relationship_relationship_type_check CHECK ((relationship_type = ANY (ARRAY['many_to_many'::text, 'one_to_many'::text, 'many_to_one'::text])))
);


ALTER TABLE public.content_relationship OWNER TO "strawb-user";

--
-- Name: content_tag; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.content_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    item_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.content_tag OWNER TO "strawb-user";

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO "strawb-user";

--
-- Name: currency; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO "strawb-user";

--
-- Name: customer; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO "strawb-user";

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO "strawb-user";

--
-- Name: customer_activity; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.customer_activity (
    id text NOT NULL,
    type text NOT NULL,
    user_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT customer_activity_type_check CHECK ((type = ANY (ARRAY['post_view'::text, 'search'::text, 'add_to_cart'::text, 'remove_from_cart'::text, 'order_placed'::text, 'order_canceled'::text, 'order_returned'::text])))
);


ALTER TABLE public.customer_activity OWNER TO "strawb-user";

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO "strawb-user";

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO "strawb-user";

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO "strawb-user";

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO "strawb-user";

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO "strawb-user";

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO "strawb-user";

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO "strawb-user";

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO "strawb-user";

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO "strawb-user";

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO "strawb-user";

--
-- Name: image; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO "strawb-user";

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO "strawb-user";

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO "strawb-user";

--
-- Name: invite; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO "strawb-user";

--
-- Name: invite_rbac_role; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.invite_rbac_role (
    invite_id character varying(255) NOT NULL,
    rbac_role_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite_rbac_role OWNER TO "strawb-user";

--
-- Name: layout_configuration; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.layout_configuration (
    id text NOT NULL,
    zone text NOT NULL,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.layout_configuration OWNER TO "strawb-user";

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO "strawb-user";

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO "strawb-user";

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO "strawb-user";

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO "strawb-user";

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO "strawb-user";

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO "strawb-user";

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    "from" text,
    provider_data jsonb,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO "strawb-user";

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO "strawb-user";

--
-- Name: order; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    custom_display_id text,
    locale text
);


ALTER TABLE public."order" OWNER TO "strawb-user";

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO "strawb-user";

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO "strawb-user";

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    carry_over_promotions boolean,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO "strawb-user";

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO "strawb-user";

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO "strawb-user";

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO "strawb-user";

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO "strawb-user";

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO "strawb-user";

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO "strawb-user";

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.order_credit_line OWNER TO "strawb-user";

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO "strawb-user";

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO "strawb-user";

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO "strawb-user";

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO "strawb-user";

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO "strawb-user";

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO "strawb-user";

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO "strawb-user";

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.order_line_item_adjustment OWNER TO "strawb-user";

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    data jsonb
);


ALTER TABLE public.order_line_item_tax_line OWNER TO "strawb-user";

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO "strawb-user";

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO "strawb-user";

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO "strawb-user";

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO "strawb-user";

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone,
    version integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO "strawb-user";

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    data jsonb
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO "strawb-user";

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO "strawb-user";

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO "strawb-user";

--
-- Name: payment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO "strawb-user";

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'partially_captured'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO "strawb-user";

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO "strawb-user";

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO "strawb-user";

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text, 'pending_authorization'::text])))
);


ALTER TABLE public.payment_session OWNER TO "strawb-user";

--
-- Name: price; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity numeric,
    max_quantity numeric,
    raw_min_quantity jsonb,
    raw_max_quantity jsonb
);


ALTER TABLE public.price OWNER TO "strawb-user";

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO "strawb-user";

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO "strawb-user";

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO "strawb-user";

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO "strawb-user";

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO "strawb-user";

--
-- Name: product; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight real,
    length real,
    height real,
    width real,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO "strawb-user";

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    external_id text
);


ALTER TABLE public.product_category OWNER TO "strawb-user";

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO "strawb-user";

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    external_id text
);


ALTER TABLE public.product_collection OWNER TO "strawb-user";

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_exclusive boolean DEFAULT false NOT NULL
);


ALTER TABLE public.product_option OWNER TO "strawb-user";

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer
);


ALTER TABLE public.product_option_value OWNER TO "strawb-user";

--
-- Name: product_product_option; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_product_option (
    id text NOT NULL,
    product_id text NOT NULL,
    product_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_product_option OWNER TO "strawb-user";

--
-- Name: product_product_option_value; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_product_option_value (
    id text NOT NULL,
    product_product_option_id text NOT NULL,
    product_option_value_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_product_option_value OWNER TO "strawb-user";

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO "strawb-user";

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO "strawb-user";

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    external_id text
);


ALTER TABLE public.product_tag OWNER TO "strawb-user";

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO "strawb-user";

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    external_id text
);


ALTER TABLE public.product_type OWNER TO "strawb-user";

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight real,
    length real,
    height real,
    width real,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    thumbnail text
);


ALTER TABLE public.product_variant OWNER TO "strawb-user";

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO "strawb-user";

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO "strawb-user";

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO "strawb-user";

--
-- Name: product_variant_product_image; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.product_variant_product_image (
    id text NOT NULL,
    variant_id text NOT NULL,
    image_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_product_image OWNER TO "strawb-user";

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    "limit" integer,
    used integer DEFAULT 0 NOT NULL,
    metadata jsonb,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO "strawb-user";

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text, 'once'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO "strawb-user";

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO "strawb-user";

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    attribute text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text, 'use_by_attribute'::text, 'spend_by_attribute'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO "strawb-user";

--
-- Name: promotion_campaign_budget_usage; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_campaign_budget_usage (
    id text NOT NULL,
    attribute_value text NOT NULL,
    used numeric DEFAULT 0 NOT NULL,
    budget_id text NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign_budget_usage OWNER TO "strawb-user";

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO "strawb-user";

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO "strawb-user";

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO "strawb-user";

--
-- Name: property_label; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.property_label (
    id text NOT NULL,
    entity text NOT NULL,
    property text NOT NULL,
    label text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.property_label OWNER TO "strawb-user";

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO "strawb-user";

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO "strawb-user";

--
-- Name: refund; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO "strawb-user";

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    code text NOT NULL
);


ALTER TABLE public.refund_reason OWNER TO "strawb-user";

--
-- Name: region; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO "strawb-user";

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO "strawb-user";

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO "strawb-user";

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO "strawb-user";

--
-- Name: return; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO "strawb-user";

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO "strawb-user";

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO "strawb-user";

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb DEFAULT '{"value": "0", "precision": 20}'::jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO "strawb-user";

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO "strawb-user";

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO "strawb-user";

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO "strawb-user";

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO "strawb-user";

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: strawb-user
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.script_migrations_id_seq OWNER TO "strawb-user";

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: strawb-user
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO "strawb-user";

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO "strawb-user";

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO "strawb-user";

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO "strawb-user";

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO "strawb-user";

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO "strawb-user";

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO "strawb-user";

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO "strawb-user";

--
-- Name: store; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO "strawb-user";

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO "strawb-user";

--
-- Name: store_locale; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.store_locale (
    id text NOT NULL,
    locale_code text NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_locale OWNER TO "strawb-user";

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO "strawb-user";

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO "strawb-user";

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO "strawb-user";

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO "strawb-user";

--
-- Name: user; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO "strawb-user";

--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.user_preference (
    id text NOT NULL,
    user_id text NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.user_preference OWNER TO "strawb-user";

--
-- Name: user_rbac_role; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.user_rbac_role (
    user_id character varying(255) NOT NULL,
    rbac_role_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.user_rbac_role OWNER TO "strawb-user";

--
-- Name: view_configuration; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.view_configuration (
    id text NOT NULL,
    entity text NOT NULL,
    name text,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.view_configuration OWNER TO "strawb-user";

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: strawb-user
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01KYYKS7QVHREARSJ4NVKM4T3X'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO "strawb-user";

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01KYYM10VZP68APXZK8WHKMPA0	pk_e2dd6b35ab22ffe975af7926356d3cdbd8021fce20353257269f707af01717f5		pk_e2d***7f5	Default Publishable API Key	publishable	\N		2026-08-01 12:15:49.632+00	\N	\N	2026-08-01 12:15:49.632+00	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01KYYNKWB7MK8RWTYEF6TC0HCS	{"user_id": "user_01KYYNKVJ36N15NC6JETPYNX29"}	2026-08-01 12:43:36.17+00	2026-08-01 12:43:36.301+00	\N
\.


--
-- Data for Name: auth_mfa_factor; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.auth_mfa_factor (id, auth_identity_id, provider, status, provider_metadata, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: auth_mfa_recovery_code; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.auth_mfa_recovery_code (id, auth_identity_id, code_hash, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: auth_password_reset_token; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.auth_password_reset_token (id, auth_identity_id, provider_identity_id, entity_id, token_hash, expires_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: auth_verification; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.auth_verification (id, auth_identity_id, entity_id, entity_type, code_provider, verified_at, requested_at, provider_metadata, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at, locale) FROM stdin;
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id, data) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id, data) FROM stdin;
\.


--
-- Data for Name: content_collection; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_collection (id, label, slug, format, prefix, metadata, created_at, updated_at, deleted_at, searchable) FROM stdin;
01KZ9QQ0MKFJC7PBDNR88YHVWT	Blog Post	gifting	html	blog/	\N	2026-08-05 19:51:54.772+00	2026-08-05 20:06:13.617+00	\N	f
01KZ9YP2EZ1CV33ZPMXRD765DW	announcement-bar	announcement-bar	text	abar/	\N	2026-08-05 21:53:43.903+00	2026-08-05 22:21:45.396+00	\N	f
01KZB64WB4J3R7F6Z6S7VVK2SZ	pages	pages	html	pages/	\N	2026-08-06 09:23:23.622+00	2026-08-06 11:42:55.255+00	\N	f
01KZBF9AEJGR6CDEMYWT47GCFH	links	links	text	links/	\N	2026-08-06 12:03:06.322+00	2026-08-06 12:03:06.322+00	\N	f
\.


--
-- Data for Name: content_creator; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_creator (id, name, bio, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: content_creator_activity; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_creator_activity (id, type, user_id, note, metadata, creator_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: content_field; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_field (id, name, label, field_type, required, options, default_value, sort_order, content_collection_id, created_at, updated_at, deleted_at) FROM stdin;
01KZ9QQ0PJPFFEZ7DD1NWTTXYJ	title	title	text	t	\N	\N	0	01KZ9QQ0MKFJC7PBDNR88YHVWT	2026-08-05 19:51:54.834+00	2026-08-05 19:51:54.835+00	\N
01KZ9QQ0QAQ7B775J18SYWZQPY	handle	handle	text	t	\N	\N	1	01KZ9QQ0MKFJC7PBDNR88YHVWT	2026-08-05 19:51:54.859+00	2026-08-05 19:51:54.859+00	\N
01KZ9QQ0QJM9KM9K5096YF0TYY	summary	Summary	text	f	\N	\N	2	01KZ9QQ0MKFJC7PBDNR88YHVWT	2026-08-05 19:51:54.866+00	2026-08-05 19:51:54.866+00	\N
01KZ9QQ0RB7T06S4WBRRQCX4GR	published_at	published_at	date	f	\N	\N	4	01KZ9QQ0MKFJC7PBDNR88YHVWT	2026-08-05 19:51:54.891+00	2026-08-05 19:55:19.086+00	\N
01KZ9QSH85QK7QVWB0VR7S2GY0	tags	Tags	multiselect	f	\N	\N	5	01KZ9QQ0MKFJC7PBDNR88YHVWT	2026-08-05 19:53:17.317+00	2026-08-05 19:55:19.104+00	\N
01KZ9QQ0R7PHQTQ4K1MNKPSS8Z	thumbnail	thumbnail	image	f	\N	\N	3	01KZ9QQ0MKFJC7PBDNR88YHVWT	2026-08-05 19:51:54.888+00	2026-08-05 19:56:32.07+00	\N
01KZ9YP2HQH0ATZ2YY8XHVCE82	url	url	text	f	\N	\N	2	01KZ9YP2EZ1CV33ZPMXRD765DW	2026-08-05 21:53:43.992+00	2026-08-05 21:53:43.992+00	\N
01KZ9YP2H29SG4ED1AQJB7MTKF	value	Value	text	t	\N	\N	0	01KZ9YP2EZ1CV33ZPMXRD765DW	2026-08-05 21:53:43.97+00	2026-08-05 21:54:59.588+00	\N
01KZ9YP2HM0CWBZCB6WMVRF4FQ	islink	isLink	boolean	t	\N	\N	1	01KZ9YP2EZ1CV33ZPMXRD765DW	2026-08-05 21:53:43.989+00	2026-08-05 21:54:59.604+00	\N
01KZB64WGFPQQAPRR4VB3P48X3	heading	Heading	text	t	\N	\N	0	01KZB64WB4J3R7F6Z6S7VVK2SZ	2026-08-06 09:23:23.792+00	2026-08-06 09:23:23.792+00	\N
01KZBF9AG2SYKAWCKGWPF5NE2G	link	link	text	f	\N	\N	1	01KZBF9AEJGR6CDEMYWT47GCFH	2026-08-06 12:03:06.371+00	2026-08-06 12:03:06.371+00	\N
01KZBF9AGH6MRC19038QDZ3Z68	ishref	ishref	boolean	t	\N	\N	2	01KZBF9AEJGR6CDEMYWT47GCFH	2026-08-06 12:03:06.385+00	2026-08-06 12:03:06.385+00	\N
01KZBF9AG6ZY4EXZ3A28WS6J26	value	value	text	f	\N	\N	0	01KZBF9AEJGR6CDEMYWT47GCFH	2026-08-06 12:03:06.375+00	2026-08-06 12:04:36.61+00	\N
01KZB64WJ80S785PZ7TEQT5KTJ	isactive	IsActive	boolean	t	\N	\N	1	01KZB64WB4J3R7F6Z6S7VVK2SZ	2026-08-06 09:23:23.848+00	2026-08-06 12:05:52.463+00	\N
\.


--
-- Data for Name: content_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_item (id, title, slug, body, status, published_at, metadata, content_collection_id, creator_id, created_at, updated_at, deleted_at) FROM stdin;
01KZ9YV34DE5TNYYZY4RMYD5SN	CLICK TO WHATSAPP 👆 	click-to-whatsapp	\N	published	2026-08-05 04:00:00+00	{"url": "https://wa.me/919999999999", "value": "CLICK TO WHATSAPP 👆 ", "islink": false}	01KZ9YP2EZ1CV33ZPMXRD765DW	\N	2026-08-05 21:56:28.43+00	2026-08-05 22:16:41.776+00	\N
01KZ9RD9BRGFGFSN1SACH3B4FF	Gifts Based on How Angry Your Girlfriend Is	gifts-based-on-how-angry-your-girlfriend-is	`\n      <p>We’ve all been there. A heated argument, some crossed words, and suddenly, your girlfriend is upset. Now, you’re wondering, what to gift your girlfriend when she is angry? Whether it’s a small misunderstanding or a bigger fallout, an apology is necessary. But here’s the tricky part—what type of gift would truly make her feel heard, valued, and loved again? We’ve got your back with a range of sorry gifts for girlfriend online, perfect for any level of anger.</p>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">Level 1: "I'm Annoyed, But Not Mad"</h2>\n      <p>At this stage, your girlfriend might be a little annoyed, but she’s not really furious. A minimal yet meaningful gift works best here. A minimal emerald necklace is the perfect choice for this level of anger. Emeralds are known for their calming and healing properties, making them an ideal gemstone when you’re trying to soothe the tension.</p>\n      <figure class="my-4">\n        <img\n          src="https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1539.jpg?v=1742232482"\n          alt="Emerald Drops"\n          class="w-full max-w-[220px] h-auto rounded-md mx-auto object-cover"\n        />\n        <figcaption class="text-sm text-gray-600 mt-2">Product displayed above: <a href="https://strawb.in/products/emerald-drops" target="_blank" rel="noopener noreferrer" class="text-primary-600">Emerald Drops</a></figcaption>\n      </figure>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">Level 2: "I'm Really Upset, But I Can Still Talk"</h2>\n      <p>When she’s still upset but open to communication, you need something a bit more meaningful to show you’re truly sorry. At this point, a couple ring can be the perfect gift. A couple ring symbolizes your bond and commitment, reminding her that despite the disagreement, you’re in this together.</p>\n      <figure class="my-4">\n        <img\n          src="https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-11-28-19h16m18s615.png?v=1732801678"\n          alt="Old Money Rings"\n          class="w-full max-w-[220px] h-auto rounded-md mx-auto object-cover"\n        />\n        <figcaption class="text-sm text-gray-600 mt-2">Product displayed above: <a href="https://strawb.in/products/old-money-rings" target="_blank" rel="noopener noreferrer" class="text-primary-600">Old Money Rings</a></figcaption>\n      </figure>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">Level 3: "I’m Extremely Angry, and We Need to Talk"</h2>\n      <p>If your girlfriend is really upset and you’ve had a serious fallout, you’ll need something more special and significant. A gemstone ring and bracelet set in her favorite color would be the perfect choice. Gemstones hold symbolic meaning, and by selecting her favorite color, you show that you’ve paid attention to her likes.</p>\n      <figure class="my-4">\n        <img\n          src="https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_2879.jpg?v=1746046186"\n          alt="Caterpillar"\n          class="w-full max-w-[220px] h-auto rounded-md mx-auto object-cover"\n        />\n        <figcaption class="text-sm text-gray-600 mt-2">Product displayed above: <a href="https://strawb.in/products/caterpillar" target="_blank" rel="noopener noreferrer" class="text-primary-600">Caterpillar</a></figcaption>\n      </figure>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">Level 4: "I Need to Calm Down, But I Love You"</h2>\n      <p>At this stage, if she’s still cooling off but open to mending things, a mix of gifts would work best. Choose a unique earring, a gemstone bracelet and ring set in her favourite colour, and a unique necklace in her favorite colour.</p>\n      <figure class="my-4">\n        <img\n          src="https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_Apr_21_2025_11_07_57_PM.png?v=1745260814"\n          alt="VeChain"\n          class="w-full max-w-[220px] h-auto rounded-md mx-auto object-cover"\n        />\n        <figcaption class="text-sm text-gray-600 mt-2">Product displayed above: <a href="https://strawb.in/products/ve-chain" target="_blank" rel="noopener noreferrer" class="text-primary-600">VeChain</a></figcaption>\n      </figure>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">How to Apologize to Your Girlfriend</h2>\n      <p>The key to any apology, whether it’s with a gift or words, is sincerity. You need to show her that you understand why she’s upset and that you’re genuinely sorry. Start by giving her space to express her feelings, and then follow it up with a thoughtful gift.</p>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">Creative and Romantic Gift Ideas</h2>\n      <p>Sometimes, the best gifts aren’t just jewelry—they’re creative gifts that show her how much you truly know her. If your girlfriend enjoys a little romance, a romantic surprise gift like a cute trinket can work wonders.</p>\n\n      <h2 class="mt-6 mb-2 text-xl font-semibold">Conclusion: The Thoughtful Apology</h2>\n      <p>When you’re wondering what to gift your girlfriend when she is angry, think about her level of anger and how much thought you want to put into the apology. From a simple jewelry gift to a couple bracelet, there are plenty of options to express your feelings. And remember, the gift is just one part of the equation—your sincere apology matters just as much.</p>\n    `	published	2026-08-05 04:00:00+00	{"tags": "girlfriend", "title": "Gifts Based on How Angry Your Girlfriend Is", "handle": "gifts-based-on-how-angry-your-girlfriend-is", "summary": "We’ve all been there. A heated argument, some crossed words, and suddenly, your girlfriend is upset. Now, you’re wondering, what to gift your girlfriend when she is angry? Whether it’s a small misunderstanding or a bigger fallout, an apology is necessary. But here’s the tricky part—what type of gift would truly make her feel heard, valued, and loved again? We’ve got your back with a range of sorry gifts for girlfriend online, perfect for any level of anger.", "thumbnail": "https://strawb.in/cdn/shop/articles/ChatGPT_Image_Jun_15_2025_03_36_51_AM.png?v=1749938887", "published_at": "2026-08-05"}	01KZ9QQ0MKFJC7PBDNR88YHVWT	\N	2026-08-05 20:04:04.6+00	2026-08-05 21:45:02.889+00	\N
01KZ9YSQFQ25Z1GNCE4YWHFYQF	BUY EVERYTHING 🍓	buy-everything	\N	published	2026-08-05 22:05:53.916+00	{"value": "BUY EVERYTHING 🍓", "islink": false}	01KZ9YP2EZ1CV33ZPMXRD765DW	\N	2026-08-05 21:55:43.735+00	2026-08-05 22:05:53.966+00	\N
01KZ9YVKRZQWY84XR10QJKBG3F	COUPONS AUTO APPLIED AT CHECKOUT	coupons-auto-applied-at-checkout	\N	published	2026-08-05 22:06:05.311+00	{"value": "COUPONS AUTO APPLIED AT CHECKOUT", "islink": false}	01KZ9YP2EZ1CV33ZPMXRD765DW	\N	2026-08-05 21:56:45.472+00	2026-08-05 22:06:05.348+00	\N
01KZ9YW81RG94XSC7XPS6DPYXQ	FREE SHIPPING ON ORDERS ABOVE ₹999	free-shipping-on-orders-above-999	\N	published	2026-08-05 22:06:08.609+00	{"value": "FREE SHIPPING ON ORDERS ABOVE ₹999", "islink": true}	01KZ9YP2EZ1CV33ZPMXRD765DW	\N	2026-08-05 21:57:06.232+00	2026-08-05 22:06:08.664+00	\N
01KZ9R18DRQK6SA1YV57XB3ZG9	Cool gifts for sister	cool-gifts-for-sister	`<article class="article-template"><div class="article-template__hero-container scroll-trigger animate--fade-in">\n            <div class="article-template__hero-medium media">\n              <img srcset="\n                  //strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985&amp;width=350 350w,\n                  //strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985&amp;width=750 750w,\n                  //strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985&amp;width=1100 1100w,\n                  //strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985&amp;width=1500 1500w,\n                  \n                  \n                  //strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985 2048w\n                " sizes="(min-width: 1200px) 1100px, (min-width: 750px) calc(100vw - 10rem), 100vw" src="//strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985&amp;width=1100" loading="eager" fetchpriority="high" width="2048" height="2048" alt="Cool gifts for sister (From a sister who’s literally begging her brother to read this)">\n            </div>\n          </div><header class="page-width page-width--narrow scroll-trigger animate--fade-in">\n          <h1 class="article-template__title">\n            Cool gifts for sister (From a sister who’s literally begging her brother to read this)\n          </h1><span class="circle-divider caption-with-letter-spacing"><time datetime="2025-07-21T14:18:27Z">July 21, 2025</time></span></header><div class="article-template__social-sharing page-width page-width--narrow scroll-trigger animate--slide-in">\n          \n          \n<script src="//strawb.in/cdn/shop/t/9/assets/share.js?v=13024540447964430191769075684" defer="defer"></script>\n\n<share-button id="Share-template--17904133341271__main" class="share-button quick-add-hidden">\n  <button class="share-button__button">\n    <span class="svg-wrapper"><svg xmlns="http://www.w3.org/2000/svg" fill="none" class="icon icon-share" viewBox="0 0 13 12"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" d="M1.625 8.125v2.167a1.083 1.083 0 0 0 1.083 1.083h7.584a1.083 1.083 0 0 0 1.083-1.083V8.125"></path><path fill="currentColor" fill-rule="evenodd" d="M6.148 1.271a.5.5 0 0 1 .707 0L9.563 3.98a.5.5 0 0 1-.707.707L6.501 2.332 4.147 4.687a.5.5 0 1 1-.708-.707z" clip-rule="evenodd"></path><path fill="currentColor" fill-rule="evenodd" d="M6.5 1.125a.5.5 0 0 1 .5.5v6.5a.5.5 0 0 1-1 0v-6.5a.5.5 0 0 1 .5-.5" clip-rule="evenodd"></path></svg>\n</span>\n    Share\n  </button>\n  <details id="Details-share-template--17904133341271__main" hidden="">\n    <summary class="share-button__button" role="button" aria-expanded="false">\n      <span class="svg-wrapper"><svg xmlns="http://www.w3.org/2000/svg" fill="none" class="icon icon-share" viewBox="0 0 13 12"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" d="M1.625 8.125v2.167a1.083 1.083 0 0 0 1.083 1.083h7.584a1.083 1.083 0 0 0 1.083-1.083V8.125"></path><path fill="currentColor" fill-rule="evenodd" d="M6.148 1.271a.5.5 0 0 1 .707 0L9.563 3.98a.5.5 0 0 1-.707.707L6.501 2.332 4.147 4.687a.5.5 0 1 1-.708-.707z" clip-rule="evenodd"></path><path fill="currentColor" fill-rule="evenodd" d="M6.5 1.125a.5.5 0 0 1 .5.5v6.5a.5.5 0 0 1-1 0v-6.5a.5.5 0 0 1 .5-.5" clip-rule="evenodd"></path></svg>\n</span>\n      Share\n    </summary>\n    <div class="share-button__fallback motion-reduce">\n      <div class="field">\n        <span id="ShareMessage-template--17904133341271__main" class="share-button__message hidden" role="status"> </span>\n        <input type="text" class="field__input" id="ShareUrl-template--17904133341271__main" value="https://strawb.in/blogs/gifting/cool-gifts-for-sister-from-a-sister-who-s-literally-begging-her-brother-to-read-this" placeholder="Link" onclick="this.select();" readonly="">\n        <label class="field__label" for="ShareUrl-template--17904133341271__main">Link</label>\n      </div>\n      <button class="share-button__close hidden">\n        <span class="svg-wrapper"><svg xmlns="http://www.w3.org/2000/svg" fill="none" class="icon icon-close" viewBox="0 0 18 17"><path fill="currentColor" d="M.865 15.978a.5.5 0 0 0 .707.707l7.433-7.431 7.579 7.282a.501.501 0 0 0 .846-.37.5.5 0 0 0-.153-.351L9.712 8.546l7.417-7.416a.5.5 0 1 0-.707-.708L8.991 7.853 1.413.573a.5.5 0 1 0-.693.72l7.563 7.268z"></path></svg>\n</span>\n        <span class="visually-hidden">Close share</span>\n      </button>\n      <button class="share-button__copy">\n        <span class="svg-wrapper"><svg class="icon icon-clipboard" width="11" height="13" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" viewBox="0 0 11 13">\n  <path fill-rule="evenodd" clip-rule="evenodd" d="M2 1a1 1 0 011-1h7a1 1 0 011 1v9a1 1 0 01-1 1V1H2zM1 2a1 1 0 00-1 1v9a1 1 0 001 1h7a1 1 0 001-1V3a1 1 0 00-1-1H1zm0 10V3h7v9H1z" fill="currentColor"></path>\n</svg>\n</span>\n        <span class="visually-hidden">Copy link</span>\n      </button>\n    </div>\n  </details>\n</share-button>\n\n        </div><div class="article-template__content page-width page-width--narrow rte scroll-trigger animate--slide-in">\n          <p dir="ltr"><span>Okay so here’s the truth — these are not&nbsp;</span><span>just</span><span> cool gifts, these are the things girls are actually obsessing over right now. She wants them. They’re either already in her cart, her wish list, or saved to her Pinterest board.</span></p>\n<p dir="ltr"><span>I’m a girl. I’m a sister. And honestly, I’d beg, borrow, steal to get these. I’m literally praying my dumbass brother reads this </span><span>Rakshabandhan</span><span> gift guide and finally gets something that doesn’t make me cry (in a bad way).</span></p>\n<p dir="ltr"><span>Whether it’s your </span><span>sister</span><span> or your B</span><span>habhi</span><span>, trust me, these R</span><span>akhi gifts</span><span> are foolproof. Let’s gooo.</span><b></b></p>\n<h2 dir="ltr"><span>1. Good Quality Jewelry</span></h2>\n<p dir="ltr"><span>Bhai, please. For the love of god. Don’t buy her those random road-side earrings that change color faster than mood rings. We’re done with that era.</span></p>\n<p dir="ltr"><span>We want </span><span>quality</span><span> jewelry that lasts. Looks good. Doesn’t turn our fingers green. There’s a brand I SWEAR by —</span><a href="https://strawb.in"><span> </span><span>Strawb.in</span></a><span>. Tried, tested, approved. I’ve had their stuff for over a year now, still shining like day one. They’ve got everything from cute adjustable necklaces to stackable rings.</span></p>\n<p dir="ltr"><span>Bonus: if you DM them, they help you pick. So literally no excuses. Just gift this. It’s the </span><span>best gift for Rakhi</span><span>, period.</span></p>\n<p><b><img src="https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_Apr_21_2025_11_07_57_PM.png?v=1745260814" alt="" width="205" height="410"><img src="https://strawb.in/cdn/shop/files/ChatGPT_Image_May_19_2025_10_50_26_PM.png?v=1747676245&amp;width=1946" width="211" height="205"></b></p>\n<p><b>In Frame: </b><a href="https://strawb.in/products/ve-chain?utm_source=website&amp;utm_medium=blogs&amp;utm_campaign=rakhi" title="VeChain" rel="noopener" target="_blank">Vechain</a></p>\n<h2 dir="ltr"><span>2. Sticky Phone Cover</span></h2>\n<p dir="ltr"><span>Okay, hear me out. I know it sounds dumb, but this is one of the most fun, useful gifts ever. It sticks to mirrors, windows, walls — and boom. Fit checks. Jewelry checks. Matcha pics. Done.</span></p>\n<p dir="ltr"><span>All the it-girls have it. She’ll thank you every time she gets the perfect click </span><span>without</span><span> needing a stand (or YOU standing there for 2 hours). You’ll be free. She’ll be happy. Win-win.</span><b></b></p>\n<h2 dir="ltr"><span>3. Skincare Goals</span></h2>\n<p dir="ltr"><span>Brother. This is </span><span>where</span><span> you score. Trust me and just pick one:</span></p>\n<ul>\n<li dir="ltr" aria-level="1">\n<p dir="ltr" role="presentation"><span>IndeWild AM + PM</span><span><br></span></p>\n</li>\n<li dir="ltr" aria-level="1">\n<p dir="ltr" role="presentation"><span>Lamel Lip Butter</span><span><br></span></p>\n</li>\n<li dir="ltr" aria-level="1">\n<p dir="ltr" role="presentation"><span>IndeWild Lip Gloss</span><span><br></span></p>\n</li>\n</ul>\n<p dir="ltr"><span>These are holy grails. Glossy, glowy, luxury-feel. A little on the expensive side? Yes. But worth every rupee. Your sister will scream. Your B</span><span>habhi</span><span> will cry. Everyone on Twitter will clap. Get two. Or three. One for you too, you deserve soft lips.</span></p>\n<p dir="ltr"><span>This is elite for R</span><span>akhi 2025</span><span>. Write that down.</span><b></b></p>\n<h2 dir="ltr"><span>4. Instant Cameras</span></h2>\n<p dir="ltr"><span>I mean, this one’s a classic. And such a vibe. Girls LOVE taking pics – of themselves, their food, their outfit, a leaf on the road. So imagine her face when you give her a Polaroid-style instant camera.</span></p>\n<p dir="ltr"><span>And brooo, you can click the cutest </span><span>Rakhi</span><span> pics together. Full family-core. This one’s sentimental </span><span>and</span><span> aesthetic.</span><b></b></p>\n<h2 dir="ltr"><span>5. Gift Cards (but make it slay)</span></h2>\n<p dir="ltr"><span>Still confused? That’s okay. Don’t panic and buy her a random candle.</span></p>\n<p dir="ltr"><span>Get her a gift card – preferably from a place she actually likes. Jewelry is always a safe bet, and again, </span><span>Strawb.in</span><span> is IT. Their gift cards are adorable and give her the power to choose her fave pieces.</span></p>\n<p dir="ltr"><span>It’s perfect for R</span><span>akhi for Bhabhi</span><span>, too. Let them both pick their favs. You’ll look rich, thoughtful, and shockingly put together.</span><b></b></p>\n<p dir="ltr"><span>So yeah. This is your sign. Don’t mess up this R</span><span>akshabandhan</span><span>. Your sister deserves a little sparkle. And if you get it right, you just might become her fav sibling.</span></p>\n<p dir="ltr"><span>No pressure though 😌</span></p>\n        </div><div class="article-template__back element-margin-top center scroll-trigger animate--slide-in">\n  </div></article>`	published	2026-08-05 20:04:29.899+00	{"tags": "divansh", "title": "Cool gifts for sister", "handle": "cool-gifts-for-sister", "summary": "From a sister who’s literally begging her brother to read this ", "thumbnail": "https://strawb.in/cdn/shop/articles/upscaled_image_2.png?v=1753110985", "published_at": "2026-08-05"}	01KZ9QQ0MKFJC7PBDNR88YHVWT	\N	2026-08-05 19:57:30.424+00	2026-08-06 12:39:46.324+00	\N
01KZBE56T7GKBN7Y4ZWM57F9MV	Contact	contact	`<div class="rte scroll-trigger animate--slide-in">\n  <main role="main" id="MainContent" class="content-for-layout focus-none" tabindex="-1">\n    <section class="prose prose-sm max-w-none text-gray-900 mx-auto px-4 sm:px-6 lg:px-8">\n      <p>Please feel free to contact us at</p>\n\n      <p class="mt-2">\n        <a href="mailto:strawb.india@gmail.com" class="text-primary-600 underline">strawb.india@gmail.com</a>\n      </p>\n\n      <address class="not-italic mt-4 text-sm text-gray-700">\n        <strong>Postal address</strong><br />\n        Aryavarta Sindhu<br />\n        Andheri East, Mumbai 99\n      </address>\n    </section>\n  </main>\n</div>\n`	published	2026-08-06 11:44:38.405+00	{"heading": "Contact", "isactive": true, "publish_date": "2026-08-06"}	01KZB64WB4J3R7F6Z6S7VVK2SZ	\N	2026-08-06 11:43:22.951+00	2026-08-06 11:44:38.422+00	\N
01KZB67CASEYPA33JRFKDB6J7E	Privacy policy	privacy-policy	<div class="rte scroll-trigger animate--slide-in">\n  <h2 class="mt-6 mb-2 text-xl font-semibold">What Do We Do With Your Information?</h2>\n  <p class="mb-4">When you purchase something from our store, as part of the buying and selling process, we collect the personal information you give us such as your name, address, and email address.</p>\n  <p class="mb-4">When you browse our store, we also automatically receive your computer’s internet protocol (IP) address in order to provide us with information that helps us learn about your browser and operating system.</p>\n  <p class="mb-4">Email marketing (if applicable): With your permission, we may send you emails about our store, new products and other updates.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Consent</h2>\n  <p class="mb-4">How do you get my consent?</p>\n  <p class="mb-4">When you provide us with personal information to complete a transaction, verify your credit card, place an order, arrange for a delivery, or return a purchase, we imply that you consent to our collecting it and using it for that specific reason only.</p>\n  <p class="mb-4">If we ask for your personal information for a secondary reason, like marketing, we will either ask you directly for your expressed consent or provide you with an opportunity to say no.</p>\n  <p class="mb-4">How do I withdraw my consent?</p>\n  <p class="mb-4">If after you opt-in, you change your mind, you may withdraw your consent for us to contact you, for the continued collection, use, or disclosure of your information, at any time, by contacting us at <a href="mailto:strawb.india@gmail.com" class="text-primary-600 underline">strawb.india@gmail.com</a>.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Disclosure</h2>\n  <p class="mb-4">We may disclose your personal information if we are required by law to do so or if you violate our Terms of Service.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Shopify</h2>\n  <p class="mb-4">Our store is hosted on Shopify Inc. They provide us with an online e-commerce platform that allows us to sell our products and services to you. Your data is stored through Shopify’s data storage, databases and the general Shopify application. They store your data on a secure server behind a firewall.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Payment</h2>\n  <p class="mb-4">If you choose a direct payment gateway to complete your purchase, then Payu stores your credit card data. It is encrypted through the Payment Card Industry Data Security Standard (PCI-DSS). Your purchase transaction data is stored only as long as is necessary to complete your purchase transaction. After that is complete, your purchase transaction information is deleted.</p>\n  <p class="mb-4">All direct payment gateways adhere to the standards set by PCI-DSS as managed by the PCI Security Standards Council, which is a joint effort of brands like Visa, MasterCard, American Express and Discover.</p>\n  <p class="mb-4">PCI-DSS requirements help ensure the secure handling of credit card information by our store and its service providers.</p>\n  <p class="mb-4">For more insight, you may also want to read Payu’s <a href="https://payu.in/tnc" target="_blank" rel="noopener noreferrer" class="text-primary-600">Terms of Service</a> or <a href="https://payu.in/privacy-policy" target="_blank" rel="noopener noreferrer" class="text-primary-600">Privacy Statement</a>.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Third‑Party Services</h2>\n  <p class="mb-4">In general, the third-party providers used by us will only collect, use and disclose your information to the extent necessary to allow them to perform the services they provide to us.</p>\n  <p class="mb-4">However, certain third-party service providers, such as payment gateways and other payment transaction processors, have their own privacy policies with respect to the information we are required to provide to them for your purchase-related transactions. For these providers, we recommend that you read their privacy policies so you can understand the manner in which your personal information will be handled by these providers.</p>\n  <p class="mb-4">In particular, remember that certain providers may be located in or have facilities that are located in a different jurisdiction than either you or us. So if you elect to proceed with a transaction that involves the services of a third-party service provider, then your information may become subject to the laws of the jurisdiction(s) in which that service provider or its facilities are located.</p>\n  <p class="mb-4">For example, if you are located in Canada and your transaction is processed by a payment gateway in the United States, then your personal information used in completing that transaction may be subject to disclosure under United States legislation, including the Patriot Act.</p>\n  <p class="mb-4">Once you leave our store’s website or are redirected to a third-party website or application, you are no longer governed by this Privacy Policy or our website’s Terms of Service.</p>\n  <p class="mb-4">Links: When you click on links on our store, they may direct you away from our site. We are not responsible for the privacy practices of other sites and encourage you to read their privacy statements.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Security</h2>\n  <p class="mb-4">To protect your personal information, we take reasonable precautions and follow industry best practices to make sure it is not inappropriately lost, misused, accessed, disclosed, altered, or destroyed.</p>\n  <p class="mb-4">If you provide us with your credit card information, the information is encrypted using secure socket layer technology (SSL) and stored with AES-256 encryption. Although no method of transmission over the Internet or electronic storage is 100% secure, we follow all PCI-DSS requirements and implement additional generally accepted industry standards.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Cookies</h2>\n  <p class="mb-4">Here is a list of cookies that we use. We’ve listed them here so that you can choose whether you want to opt out of cookies.</p>\n  <ul class="list-disc pl-6 mb-4">\n    <li><strong>_session_id</strong>: unique token, sessional, allows Shopify to store information about your session (referrer, landing page, etc).</li>\n    <li><strong>_Shopify_visit</strong>: no data held, persistent for 30 minutes from the last visit, used by our website provider’s internal stats tracker to record the number of visits.</li>\n    <li><strong>_Shopify_uniq</strong>: no data held, expires midnight of the next day, counts the number of visits to a store by a single customer.</li>\n    <li><strong>cart</strong>: unique token, persistent for 2 weeks, stores information about the contents of your cart.</li>\n    <li><strong>_secure_session_id</strong>: unique token, sessional.</li>\n    <li><strong>storefront_digest</strong>: unique token, indefinite, used to determine if the current visitor has access when the shop has a password.</li>\n  </ul>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Age of Consent</h2>\n  <p class="mb-4">By using this site, you represent that you are at least the age of majority in your state or province of residence, or that you are the age of majority in your state or province of residence and you have given us your consent to allow any of your minor dependents to use this site.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Changes to This Privacy Policy</h2>\n  <p class="mb-4">We reserve the right to modify this privacy policy at any time, so please review it frequently. Changes and clarifications will take effect immediately upon their posting on the website. If we make material changes to this policy, we will notify you here that it has been updated, so that you are aware of what information we collect, how we use it, and under what circumstances, if any, we use and/or disclose it.</p>\n  <p class="mb-4">If our store is acquired or merged with another company, your information may be transferred to the new owners so that we may continue to sell products to you.</p>\n</div>\n	published	2026-08-06 11:44:27.776+00	{"heading": "Privacy policy", "isactive": true, "publish_date": "2026-08-06"}	01KZB64WB4J3R7F6Z6S7VVK2SZ	\N	2026-08-06 09:24:45.53+00	2026-08-06 18:43:27.321+00	\N
01KZB69CMYZRWEYAF1B4FXTH40	Terms of Service	terms-of-service	<div class="rte scroll-trigger animate--slide-in">\n  <h1 class="text-2xl font-semibold mb-6">Terms of Service</h1>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Overview</h2>\n  <p class="mb-4">This website is operated by Strawb. Throughout the site, the terms “we”, “us” and “our” refer to Strawb. Strawb offers this website, including all information, tools and services available from this site to you, the user, conditioned upon your acceptance of all terms, conditions, policies and notices stated here. By visiting our site and/or purchasing something from us, you engage in our “Service” and agree to be bound by the following terms and conditions (“Terms of Service”, “Terms”), including those additional terms and conditions and policies referenced herein and/or available by hyperlink.</p>\n  <p class="mb-4">By accessing or using any part of the site, you agree to be bound by these Terms of Service. If you do not agree, you may not access the website or use any services. Any new features or tools added to the current store shall also be subject to the Terms of Service. You can review the most current version at any time on this page.</p>\n  <p class="mb-4">We reserve the right to update, change or replace any part of these Terms by posting updates to our website. Your continued use of or access to the website following the posting of any changes constitutes acceptance of those changes. Our store is hosted on Shopify, which provides us with the e‑commerce platform.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Online Store Terms</h2>\n  <p class="mb-4">By agreeing to these Terms of Service, you represent that you are at least the age of majority in your state or province of residence, or that you have given consent for your minor dependents to use this site.</p>\n  <p class="mb-4">You may not use our products for any illegal or unauthorized purpose nor may you violate any laws in your jurisdiction. You must not transmit any worms, viruses, or destructive code. A breach of any Terms will result in immediate termination of your Services.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">General Conditions</h2>\n  <p class="mb-4">We reserve the right to refuse service to anyone for any reason at any time. Your content (not including credit card information) may be transferred unencrypted across networks. Credit card information is always encrypted during transfer.</p>\n  <p class="mb-4">You agree not to reproduce, duplicate, copy, sell, resell or exploit any portion of the Service without express written permission. Headings are included for convenience only.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Accuracy, Completeness and Timeliness of Information</h2>\n  <p class="mb-4">We are not responsible if information on this site is not accurate, complete or current. Material is provided for general information only. Any reliance is at your own risk. Historical information is provided for reference only.</p>\n  <p class="mb-4">We reserve the right to modify contents at any time but have no obligation to update. You agree it is your responsibility to monitor changes.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Modifications to the Service and Prices</h2>\n  <p class="mb-4">Prices for our products are subject to change without notice. We may modify or discontinue the Service at any time without liability.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Products or Services</h2>\n  <p class="mb-4">Certain products or services may be available exclusively online. These may have limited quantities and are subject to return or exchange only according to our Return Policy. Colours and images are displayed as accurately as possible, but we cannot guarantee monitor accuracy.</p>\n  <p class="mb-4">We reserve the right to limit sales by person, region or jurisdiction, and to limit quantities. All descriptions and pricing are subject to change without notice. We do not warrant that product quality will meet expectations or that errors will be corrected.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Accuracy of Billing and Account Information</h2>\n  <p class="mb-4">We reserve the right to refuse any order. We may limit or cancel quantities per person, household or order. Restrictions may include orders under the same account, card, or address. If we change or cancel an order, we may notify you via email or billing details provided. We may prohibit orders that appear to be placed by dealers or resellers.</p>\n  <p class="mb-4">You agree to provide current, complete and accurate purchase and account information, and promptly update your details. See our Returns Policy for more detail.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Optional Tools</h2>\n  <p class="mb-4">We may provide access to third‑party tools “as is” and “as available” without warranties. We have no liability for your use of such tools. Future new services or features will also be subject to these Terms.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Third‑Party Links</h2>\n  <p class="mb-4">Content, products and services may include materials from third parties. Links may direct you to third‑party websites not affiliated with us. We are not responsible for their content or accuracy. We are not liable for harm or damages related to third‑party transactions. Please review third‑party policies before engaging.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">User Comments, Feedback and Other Submissions</h2>\n  <p class="mb-4">If you send creative ideas, suggestions, proposals, or other materials (“comments”), you agree we may use them without restriction. We are under no obligation to maintain comments in confidence, pay compensation, or respond. We may monitor or remove unlawful or objectionable content.</p>\n  <p class="mb-4">You agree your comments will not violate third‑party rights, contain unlawful or obscene material, or malware. You may not mislead us or others. You are solely responsible for your comments.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Personal Information</h2>\n  <p class="mb-4">Your submission of personal information is governed by our Privacy Policy.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Errors, Inaccuracies and Omissions</h2>\n  <p class="mb-4">Occasionally information may contain errors or omissions relating to product descriptions, pricing, promotions, shipping charges, transit times and availability. We reserve the right to correct errors and cancel orders if information is inaccurate.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Prohibited Uses</h2>\n  <p class="mb-4">You are prohibited from using the site or its content for unlawful purposes, soliciting unlawful acts, violating laws, infringing intellectual property, harassing or discriminating, submitting false information, uploading viruses, collecting personal information, spamming, scraping, obscene purposes, or interfering with security features. We may terminate your use for violations.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Disclaimer of Warranties; Limitation of Liability</h2>\n  <p class="mb-4">We do not guarantee that use of our service will be uninterrupted, timely, secure or error‑free. You agree use is at your sole risk. Services and products are provided “as is” and “as available” without warranties. Strawb and affiliates are not liable for any damages arising from use of the service or products.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Indemnification</h2>\n  <p class="mb-4">You agree to indemnify and hold harmless Strawb and affiliates from any claims or demands arising out of your breach of these Terms or violation of law or rights of a third party.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Severability</h2>\n  <p class="mb-4">If any provision is unlawful or unenforceable, it shall be severed, and the remainder shall remain valid.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Termination</h2>\n  <p class="mb-4">These Terms are effective unless terminated by you or us. You may terminate by ceasing use of the site. We may terminate without notice if you fail to comply, and you remain liable for amounts due up to termination.</p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Entire Agreement</h2>\n    <p class="mb-4">\n    These Terms of Service and any policies or operating rules posted by us on this site or in respect to the Service constitute the entire agreement and understanding between you and us and govern your use of the Service, superseding any prior or contemporaneous agreements, communications and proposals, whether oral or written, between you and us (including, but not limited to, any prior versions of the Terms of Service).\n  </p>\n  <p class="mb-4">\n    Any ambiguities in the interpretation of these Terms of Service shall not be construed against the drafting party.\n  </p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Governing Law</h2>\n  <p class="mb-4">\n    These Terms of Service and any separate agreements whereby we provide you Services shall be governed by and construed in accordance with the laws of Maharashtra, India.\n  </p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Changes to Terms of Service</h2>\n  <p class="mb-4">\n    You can review the most current version of the Terms of Service at any time at this page. We reserve the right, at our sole discretion, to update, change or replace any part of these Terms of Service by posting updates and changes to our website. It is your responsibility to check our website periodically for changes. Your continued use of or access to our website or the Service following the posting of any changes to these Terms of Service constitutes acceptance of those changes.\n  </p>\n\n  <h2 class="mt-6 mb-2 text-xl font-semibold">Contact Information</h2>\n  <p class="mb-4">\n    Questions about the Terms of Service should be sent to us at <a href="mailto:strawb.india@gmail.com" class="text-primary-600 underline">strawb.india@gmail.com</a>.\n  </p>\n</div>\n	published	2026-08-06 11:44:41.542+00	{"heading": "Terms of Service", "isactive": true, "publish_date": "2026-08-06"}	01KZB64WB4J3R7F6Z6S7VVK2SZ	\N	2026-08-06 09:25:51.391+00	2026-08-06 19:27:40.935+00	\N
01KZB688W9EWVQK2875Y6K4524	Refund policy	refund-policy	<div class="rte scroll-trigger animate--slide-in">\n  <h1 class="text-2xl font-semibold mb-6">Refund & Exchange Policy</h1>\n\n  <section>\n    <p class="mb-4">\n      We follow a strict only exchange policy that excludes returns and refunds. Our policy lasts 7 days. If 7 days have gone by since your product delivery, unfortunately, we can’t offer you an exchange. In case we receive an eligible product for an exchange, the same shall be processed within 7 days.\n    </p>\n  </section>\n\n  <section>\n    <h2 class="mt-6 mb-2 text-xl font-semibold">Exchange Eligibility</h2>\n    <p class="mb-4">\n      To be eligible for an exchange, your item must be unused and in the same condition that you received it. It must also be in the original packaging along with the product tags and labels intact.\n    </p>\n    <p class="mb-4 font-semibold">To initiate an exchange the customer needs to:</p>\n    <p class="mb-4">\n      Send a WhatsApp message to <a href="tel:+918097671106" class="text-primary-600">+91 8097671106</a> or email <a href="mailto:strawb.india@gmail.com" class="text-primary-600">strawb.india@gmail.com</a> with the reason for the return along with proof of purchase. (Please attach pictures of the issues). If your reason is justified, you will have to arrange a pickup (please do not send your purchase back to the manufacturer). You will be given the return address.\n    </p>\n    <p class="mb-4">\n      Once your return is received and inspected, we will send you an email to notify you that we have received your returned item. We will also notify you of the approval or rejection of your exchange. Depending on where you live, the time it may take for your exchanged product to reach you may vary.\n    </p>\n  </section>\n\n  <section>\n    <h2 class="mt-6 mb-2 text-xl font-semibold">Refund Process</h2>\n    <p class="mb-4">\n      After inspection of the product, if the product is intact the refund will be issued within 4–5 working days to the customer on their original payment method. The refund will not include the shipping amount.\n    </p>\n  </section>\n</div>\n	published	2026-08-06 11:44:31.774+00	{"heading": "Refund policy", "isactive": true, "publish_date": "2026-08-06"}	01KZB64WB4J3R7F6Z6S7VVK2SZ	\N	2026-08-06 09:25:14.763+00	2026-08-06 18:58:14.292+00	\N
01KZBFB8PF1MXY3818B54SMZFP	Instgram	instgram	\N	published	2026-08-06 12:09:26.559+00	{"link": "https://www.instagram.com/strawb.in", "value": null, "ishref": true}	01KZBF9AEJGR6CDEMYWT47GCFH	\N	2026-08-06 12:04:10.064+00	2026-08-06 12:09:26.578+00	\N
01KZBFMGYQ4J5689EW3F368W8P	whatsapp	whatsapp	\N	published	2026-08-06 12:09:30.63+00	{"link": "https://api.whatsapp.com/send/?phone=%2B918097671106&text=Hey%21+Strawb&type=phone_number&app_absent=0", "ishref": true}	01KZBF9AEJGR6CDEMYWT47GCFH	\N	2026-08-06 12:09:13.431+00	2026-08-06 12:09:30.65+00	\N
01KZB68SAM6QA65NEPQY4Z3J0P	Shipping policy	shipping-policy	<div class="rte scroll-trigger animate--slide-in">\n  <main role="main" id="MainContent" class="content-for-layout focus-none" tabindex="-1">\n    <div class="shopify-policy__container">\n      \n\n      <div class="shopify-policy__body prose prose-sm max-w-none text-gray-900">\n        <section>\n          <h2 class="mt-6 mb-2 text-xl font-semibold">Shipment</h2>\n          <p class="mb-4">\n            Delivery takes a minimum of 14 days and a maximum of 20 days. All our products are shipped through Shiprocket’s partners and you will receive live tracking links after payment confirmation.\n          </p>\n        </section>\n\n        <section>\n          <h2 class="mt-6 mb-2 text-xl font-semibold">Exchange</h2>\n          <p class="mb-4">\n            Goods shall be exchanged only if the product is damaged or there is any issue with sizing. Any replacement product will be sent only after examining the damaged product. To be eligible for an exchange, your item must be unused and in the same condition that you received it. It must also be in the original packaging along with the product tags and labels intact. In case we receive an eligible product for an exchange, the same shall be processed within 7 days.\n          </p>\n        </section>\n\n        <section>\n          <h2 class="mt-6 mb-2 text-xl font-semibold">Return Address</h2>\n          <p class="mb-4">\n            We will supply you the return slip to stick.\n          </p>\n        </section>\n      </div>\n    </div>\n  </main>\n</div>\n	published	2026-08-06 11:44:35.061+00	{"heading": "Shipping policy", "isactive": true, "publish_date": "2026-08-06"}	01KZB64WB4J3R7F6Z6S7VVK2SZ	\N	2026-08-06 09:25:31.605+00	2026-08-06 18:54:57.736+00	\N
\.


--
-- Data for Name: content_item_activity; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_item_activity (id, type, user_id, note, metadata, item_id, created_at, updated_at, deleted_at) FROM stdin;
01KZ9R8YMR99FDASM2JNP8R8WT	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9R18DRQK6SA1YV57XB3ZG9	2026-08-05 20:01:42.552+00	2026-08-05 20:01:42.552+00	\N
01KZ9RDY4GV0VYTZ8B068DMMT8	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9R18DRQK6SA1YV57XB3ZG9	2026-08-05 20:04:25.872+00	2026-08-05 20:04:25.872+00	\N
01KZ9RE23DDE8CGSHF0XGS3T4D	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9R18DRQK6SA1YV57XB3ZG9	2026-08-05 20:04:29.934+00	2026-08-05 20:04:29.934+00	\N
01KZ9RF0SESC51WV1BGBQ6BZ59	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 20:05:01.358+00	2026-08-05 20:05:01.358+00	\N
01KZ9RF380DC31RJAW89S9DCM5	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 20:05:03.872+00	2026-08-05 20:05:03.872+00	\N
01KZ9W2S36X06G53514ZBWTWP5	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:08:14.566+00	2026-08-05 21:08:14.566+00	\N
01KZ9XB3X58DQJN3PGGCA6PN1E	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:30:16.357+00	2026-08-05 21:30:16.357+00	\N
01KZ9XKY1N3J6VTDD8ZEW2Z2HF	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:35:05.27+00	2026-08-05 21:35:05.27+00	\N
01KZ9XVQ70XYETYQD5WDKX3KK0	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:39:20.417+00	2026-08-05 21:39:20.417+00	\N
01KZ9XX2T8P19MYBMV995AWT7M	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:40:05.064+00	2026-08-05 21:40:05.064+00	\N
01KZ9Y2XYD4831HHSPG2N80254	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:43:16.685+00	2026-08-05 21:43:16.685+00	\N
01KZ9Y65NRY3KBGACMB1JZRYBX	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:45:02.905+00	2026-08-05 21:45:02.905+00	\N
01KZ9Y65TD4BD49PCHWCDBJR23	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9RD9BRGFGFSN1SACH3B4FF	2026-08-05 21:45:03.053+00	2026-08-05 21:45:03.053+00	\N
01KZ9ZCBFQT5M8RJ1YF30QSYBQ	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9YSQFQ25Z1GNCE4YWHFYQF	2026-08-05 22:05:54.04+00	2026-08-05 22:05:54.04+00	\N
01KZ9ZCJF9C911T02T1TKA3CZV	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9YV34DE5TNYYZY4RMYD5SN	2026-08-05 22:06:01.194+00	2026-08-05 22:06:01.194+00	\N
01KZ9ZCPK1S9MPVS9R440P3ESY	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9YVKRZQWY84XR10QJKBG3F	2026-08-05 22:06:05.41+00	2026-08-05 22:06:05.41+00	\N
01KZ9ZCSW7C0KE467EES7C0TT1	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9YW81RG94XSC7XPS6DPYXQ	2026-08-05 22:06:08.782+00	2026-08-05 22:06:08.782+00	\N
01KZA0042543YTSRNNNPC5ZW4N	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9YV34DE5TNYYZY4RMYD5SN	2026-08-05 22:16:41.798+00	2026-08-05 22:16:41.798+00	\N
01KZB6EKT0AF2AJWY1CCVED83K	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB67CASEYPA33JRFKDB6J7E	2026-08-06 09:28:42.561+00	2026-08-06 09:28:42.561+00	\N
01KZB6GJZEQYYTTGWX12AT4RY9	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 09:29:47.247+00	2026-08-06 09:29:47.247+00	\N
01KZB6JSFAFA36TJHNZ5HMMERM	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 09:30:59.435+00	2026-08-06 09:30:59.435+00	\N
01KZB6PHB0JM9NTZA39XBK2NPM	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB69CMYZRWEYAF1B4FXTH40	2026-08-06 09:33:02.177+00	2026-08-06 09:33:02.177+00	\N
01KZBE6R6TAZD7MTNZPBRSJ2HS	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBE56T7GKBN7Y4ZWM57F9MV	2026-08-06 11:44:13.53+00	2026-08-06 11:44:13.53+00	\N
01KZBE7655AQF0T170KSC6AHG6	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB67CASEYPA33JRFKDB6J7E	2026-08-06 11:44:27.814+00	2026-08-06 11:44:27.814+00	\N
01KZBE7A22D9RXPE6B8Z9D4QEH	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 11:44:31.81+00	2026-08-06 11:44:31.81+00	\N
01KZBE7D98G0YCNXRDMRAX5YB2	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 11:44:35.113+00	2026-08-06 11:44:35.113+00	\N
01KZBE7GGYH8608F1H55W11P68	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBE56T7GKBN7Y4ZWM57F9MV	2026-08-06 11:44:38.43+00	2026-08-06 11:44:38.43+00	\N
01KZBE7KK4EAHGS8VBSBG7718F	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB69CMYZRWEYAF1B4FXTH40	2026-08-06 11:44:41.572+00	2026-08-06 11:44:41.572+00	\N
01KZBFFEE0M1CHD8D5XDZA9NMD	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBFB8PF1MXY3818B54SMZFP	2026-08-06 12:06:27.008+00	2026-08-06 12:06:27.008+00	\N
01KZBFFKCQBC1SPWVPTT01KZQ4	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBFB8PF1MXY3818B54SMZFP	2026-08-06 12:06:32.087+00	2026-08-06 12:06:32.087+00	\N
01KZBFMQNEGER9HW177Y4PMB0C	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBFB8PF1MXY3818B54SMZFP	2026-08-06 12:09:20.302+00	2026-08-06 12:09:20.302+00	\N
01KZBFMXSSC2JPHEBX7F038812	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBFB8PF1MXY3818B54SMZFP	2026-08-06 12:09:26.586+00	2026-08-06 12:09:26.586+00	\N
01KZBFN1SBGVF6SJMGBEGFAFMF	publish	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZBFMGYQ4J5689EW3F368W8P	2026-08-06 12:09:30.668+00	2026-08-06 12:09:30.668+00	\N
01KZBH8R0NRD36XN60PN8F9XS6	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 12:37:44.598+00	2026-08-06 12:37:44.598+00	\N
01KZBH9W8YA3KBM8NRAF51ZMVR	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 12:38:21.727+00	2026-08-06 12:38:21.727+00	\N
01KZBHCEYVC3X83DBPA9SR390X	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZ9R18DRQK6SA1YV57XB3ZG9	2026-08-06 12:39:46.396+00	2026-08-06 12:39:46.396+00	\N
01KZBKPESNB9XWTT7R7904JPGK	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB67CASEYPA33JRFKDB6J7E	2026-08-06 13:20:11.061+00	2026-08-06 13:20:11.061+00	\N
01KZBKQ1AP0SWYWPZ8Z6SRYJBP	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB67CASEYPA33JRFKDB6J7E	2026-08-06 13:20:30.038+00	2026-08-06 13:20:30.038+00	\N
01KZC66CFCXSHJKWEWAM5H0PAC	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB67CASEYPA33JRFKDB6J7E	2026-08-06 18:43:27.34+00	2026-08-06 18:43:27.34+00	\N
01KZC66DSEFQGWH7PXXMHAY654	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB67CASEYPA33JRFKDB6J7E	2026-08-06 18:43:28.686+00	2026-08-06 18:43:28.686+00	\N
01KZC6BP47XNEF7E31CZAK11FV	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 18:46:21.063+00	2026-08-06 18:46:21.063+00	\N
01KZC6CXXBB9KSJEH5YPT61GZW	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 18:47:01.803+00	2026-08-06 18:47:01.803+00	\N
01KZC6JC2Q9KE3HE8NHFN8708Z	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 18:50:00.151+00	2026-08-06 18:50:00.151+00	\N
01KZC6K606HF59JZAHA6EF2JPJ	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 18:50:26.694+00	2026-08-06 18:50:26.694+00	\N
01KZC6M5K8RR4MSJR77CMFFZNA	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 18:50:59.048+00	2026-08-06 18:50:59.048+00	\N
01KZC6SE8YHDA79PDGBK7E40MW	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 18:53:51.775+00	2026-08-06 18:53:51.775+00	\N
01KZC6TQ1BACK9G1CBNDVBH3V5	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 18:54:33.515+00	2026-08-06 18:54:33.515+00	\N
01KZC6V43EX0D1KEP4JRQD198H	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 18:54:46.894+00	2026-08-06 18:54:46.894+00	\N
01KZC6VEPQQFD5JNY4W8GA5GJ1	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB68SAM6QA65NEPQY4Z3J0P	2026-08-06 18:54:57.751+00	2026-08-06 18:54:57.751+00	\N
01KZC71EN5ZW3VK5TAM2DHACW5	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB688W9EWVQK2875Y6K4524	2026-08-06 18:58:14.309+00	2026-08-06 18:58:14.309+00	\N
01KZC8QBWTHA5JNPFA5GQ0SC62	edit	user_01KYYNKVJ36N15NC6JETPYNX29	\N	\N	01KZB69CMYZRWEYAF1B4FXTH40	2026-08-06 19:27:40.954+00	2026-08-06 19:27:40.954+00	\N
\.


--
-- Data for Name: content_link; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_link (id, source_item_id, target_item_id, relationship_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: content_relationship; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_relationship (id, relationship_type, source_collection_id, target_collection_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: content_tag; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.content_tag (id, value, metadata, item_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2026-08-01 12:14:52.229+00	2026-08-01 12:14:52.229+00	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2026-08-01 12:14:52.233+00	2026-08-01 12:14:52.233+00	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2026-08-01 12:14:52.233+00	2026-08-01 12:14:52.233+00	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2026-08-01 12:14:52.233+00	2026-08-01 12:14:52.233+00	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2026-08-01 12:14:52.233+00	2026-08-01 12:14:52.233+00	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2026-08-01 12:14:52.233+00	2026-08-01 12:14:52.233+00	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2026-08-01 12:14:52.234+00	2026-08-01 12:14:52.234+00	\N
aoa	AOA	Kz	2	0	{"value": "0", "precision": 20}	Angolan Kwanza	2026-08-01 12:14:52.234+00	2026-08-01 12:14:52.234+00	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2026-08-01 12:14:52.234+00	2026-08-01 12:14:52.234+00	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2026-08-01 12:14:52.235+00	2026-08-01 12:14:52.235+00	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2026-08-01 12:14:52.236+00	2026-08-01 12:14:52.236+00	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2026-08-01 12:14:52.237+00	2026-08-01 12:14:52.237+00	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
gmd	D	D	2	0	{"value": "0", "precision": 20}	Gambian Dalasi	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2026-08-01 12:14:52.238+00	2026-08-01 12:14:52.238+00	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
irt	IRT	تومان	0	0	{"value": "0", "precision": 20}	Iranian Toman	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2026-08-01 12:14:52.239+00	2026-08-01 12:14:52.239+00	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2026-08-01 12:14:52.24+00	2026-08-01 12:14:52.24+00	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mwk	K	K	2	0	{"value": "0", "precision": 20}	Malawian Kwacha	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2026-08-01 12:14:52.241+00	2026-08-01 12:14:52.241+00	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.242+00	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2026-08-01 12:14:52.242+00	2026-08-01 12:14:52.243+00	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.243+00	\N
tjs	TJS	с.	2	0	{"value": "0", "precision": 20}	Tajikistani Somoni	2026-08-01 12:14:52.243+00	2026-08-01 12:14:52.244+00	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2026-08-01 12:14:52.244+00	2026-08-01 12:14:52.244+00	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
xpf	₣	₣	0	0	{"value": "0", "precision": 20}	CFP Franc	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2026-08-01 12:14:52.245+00	2026-08-01 12:14:52.245+00	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_activity; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.customer_activity (id, type, user_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2026-08-01 12:14:52.447+00	2026-08-01 12:14:52.448+00	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01KYYM11N9M85PX2PD9JN4DCFX	European Warehouse delivery	shipping	\N	2026-08-01 12:15:50.443+00	2026-08-01 12:15:50.443+00	\N
fuset_01KZ7ERWTD8QAWWT7WJTZHJJCK	Andheri pick up	pickup	\N	2026-08-04 22:37:10.349+00	2026-08-04 22:37:10.349+00	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01KYYM11MVW5SDF4EK1DJ9GDYH	country	gb	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.444+00	2026-08-01 12:15:50.444+00	\N
fgz_01KYYM11MWR8REH6SVD7B2KG5J	country	de	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.445+00	2026-08-01 12:15:50.445+00	\N
fgz_01KYYM11MXBN3X9B0V93KBK94H	country	dk	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.445+00	2026-08-01 12:15:50.445+00	\N
fgz_01KYYM11MX6DDY8VYZ8Z0VAEFY	country	se	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.445+00	2026-08-01 12:15:50.445+00	\N
fgz_01KYYM11N2B0X9JPRQV0H45B1W	country	fr	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.445+00	2026-08-01 12:15:50.445+00	\N
fgz_01KYYM11N3BAAZWGRZA4VQZS7V	country	es	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.445+00	2026-08-01 12:15:50.445+00	\N
fgz_01KYYM11N3DT4QCJBBV9K835VN	country	it	\N	\N	serzo_01KYYM11N976QR3F041CH9F994	\N	\N	2026-08-01 12:15:50.445+00	2026-08-01 12:15:50.445+00	\N
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01KZ6CDKZDA3AGKBF6VW4HKCFR	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2024-09-20_at_5.20.58_PM-2.jpg?v=1727391692	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	0	prod_01KZ6CDKYNFYQ8KEWXD75JHSMR
img_01KZ6CDKZDJWD80YTP7G170VRJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsAppImage2024-09-20at4.48.42PM_1.jpg?v=1727391586	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	1	prod_01KZ6CDKYNFYQ8KEWXD75JHSMR
img_01KZ6CDKZERJ52QYKPD8NKTRCP	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_0bcebe9f-3485-43c7-a1ad-f825eaa4911b.jpg?v=1717248837	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	0	prod_01KZ6CDKYNR4MMKW0P0TKPM2EY
img_01KZ6CDKZEYXXY3T2S8S3FRKHJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_126904f0-7cbe-455b-84e8-ff1d6c2fbfd9.jpg?v=1717248837	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	1	prod_01KZ6CDKYNR4MMKW0P0TKPM2EY
img_01KZ6CDKZFZPBDD48M37ZPTSBH	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Apr_22_2025_02_14_34_AM.jpg?v=1746044142	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZF1TJRZ6F8HSJH3N4V	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5130.png?v=1754350084	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	1	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZG9NMWHQM2VJ2RQH8A	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/silver_bamboo_bangle.jpg?v=1754350084	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	2	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZG2YKRS3AR52QB2AEB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2024-09-05_at_2.24.24_PM_2.jpg?v=1754350065	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	3	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZGTWMGJ61HTE0MXXY8	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2024-09-27_at_10.02.27_PM_2.jpg?v=1754350065	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	4	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZG360W7XSS6G6HJH9Q	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-01h21m32s929.png?v=1754350065	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	5	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZHSTA34HBRWPEQ4AV0	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsAppImage2024-09-01at12.29.55AM.jpg?v=1754350065	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	6	prod_01KZ6CDKYN61S7DVMW2DEQXG56
img_01KZ6CDKZJGCC9Y8P01K084RQX	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5298.png?v=1729988251	\N	2026-08-04 12:36:49.491+00	2026-08-04 12:36:49.491+00	\N	0	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA
img_01KZ6CDKZJ583E0XQF7A1FJJ32	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-10-21-02h03m01s302.png?v=1729456658	\N	2026-08-04 12:36:49.492+00	2026-08-04 12:36:49.492+00	\N	1	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA
img_01KZ6CDKZJKK62WR6DP3JRH03Z	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5301_1.png?v=1729988280	\N	2026-08-04 12:36:49.492+00	2026-08-04 12:36:49.492+00	\N	2	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA
img_01KZ6CDKZJMNB33YXBXJNF024F	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5303.png?v=1729988503	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	3	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA
img_01KZ6CDKZJ945EZ4JK5HNGVV1R	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5305.png?v=1729988474	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	4	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA
img_01KZ6CDKZK8NY44WGDD991EPQP	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_1e288065-e1ad-4fc4-80b7-afdb6a3a3ce5.jpg?v=1717244194	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	0	prod_01KZ6CDKYNSVSVB52D31W5Z60T
img_01KZ6CDKZKSR8RRSFQTEQF89MA	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_5226bd11-eea8-4138-8375-1e476b942c6b.jpg?v=1717244194	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	1	prod_01KZ6CDKYNSVSVB52D31W5Z60T
img_01KZ6CDKZKR57505FRZY1PEGX9	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_4a4ec3eb-8c03-4d5e-b334-a86ae1e71c2d.jpg?v=1717244194	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	2	prod_01KZ6CDKYNSVSVB52D31W5Z60T
img_01KZ6CDKZM4M38N01N7HTSFMVX	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_1d465bc2-455b-4f12-be7b-bf1b79abdfc9.jpg?v=1717243588	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	0	prod_01KZ6CDKYPM773V64EKZDC8TZ3
img_01KZ6CDKZMDXAXBZ53JBZGX9Q6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_07cd3e5b-3b3c-43f5-8099-4ffead8e7a92.jpg?v=1717243588	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	1	prod_01KZ6CDKYPM773V64EKZDC8TZ3
img_01KZ6CDKZMS8FG4QJ3NKQF7XP8	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_f201f358-1de8-4f44-ab2c-70a71d777cd6.jpg?v=1717243589	\N	2026-08-04 12:36:49.493+00	2026-08-04 12:36:49.493+00	\N	2	prod_01KZ6CDKYPM773V64EKZDC8TZ3
img_01KZ6CDKZMEFYTNW3ZRYQW7P1Q	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/4_ba57d47f-9b21-4675-b2f0-78949275247b.jpg?v=1717243588	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	3	prod_01KZ6CDKYPM773V64EKZDC8TZ3
img_01KYYM12HZFRF157ZMPJD5H3C2	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2026-08-01 12:15:51.422+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	0	prod_01KYYM12HNB3B06MTFGRDQ6HER
img_01KYYM12HZ2NHCQ9N48C7NPPNX	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:30.552+00	2026-08-04 17:20:30.531+00	1	prod_01KYYM12HNB3B06MTFGRDQ6HER
img_01KYYM12J0HETE7ZX1SGA564GB	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:30.552+00	2026-08-04 17:20:30.531+00	2	prod_01KYYM12HNB3B06MTFGRDQ6HER
img_01KYYM12J1VC8WH0VPZMKZ62AX	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:30.552+00	2026-08-04 17:20:30.531+00	3	prod_01KYYM12HNB3B06MTFGRDQ6HER
img_01KYYM12JC0RASPFVG1FJ270CK	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:33.406+00	2026-08-04 17:20:33.386+00	0	prod_01KYYM12HPCG0WKM9PV50YN7NH
img_01KYYM12JDER870HJAVFJWEBRN	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2026-08-01 12:15:51.424+00	2026-08-04 17:20:33.406+00	2026-08-04 17:20:33.386+00	1	prod_01KYYM12HPCG0WKM9PV50YN7NH
img_01KYYM12J80YF23KHV148A4289	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:36.699+00	2026-08-04 17:20:36.673+00	0	prod_01KYYM12HPFK3M2KARA0JVMBZV
img_01KYYM12J9V4J2YHVQRW4XYW3R	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:36.699+00	2026-08-04 17:20:36.673+00	1	prod_01KYYM12HPFK3M2KARA0JVMBZV
img_01KYYM12J55ZS2H742DWWE0DWQ	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:40.422+00	2026-08-04 17:20:40.404+00	0	prod_01KYYM12HPNF1205QN0N30DVZ7
img_01KYYM12J6B6CM538NSCKKPY1G	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2026-08-01 12:15:51.423+00	2026-08-04 17:20:40.422+00	2026-08-04 17:20:40.404+00	1	prod_01KYYM12HPNF1205QN0N30DVZ7
img_01KZ6CDKZNC4N3N88DWT4FFYMY	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/5_152a9137-7deb-4a0b-bf0c-885d02d7e23f.jpg?v=1717243588	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	4	prod_01KZ6CDKYPM773V64EKZDC8TZ3
img_01KZ6CDKZN01EMHX6SP2SA6KQ0	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/6.jpg?v=1717243588	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	5	prod_01KZ6CDKYPM773V64EKZDC8TZ3
img_01KZ6CDKZN41RZJCDAB18AQ9FK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_2872.jpg?v=1746046186	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZPWT4FXKW3TRH7KEV1	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_2879.jpg?v=1746046186	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	1	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZPH7E7386GXPAPTS2X	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vg1.jpg?v=1746043310	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	2	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZP8ZMTRV268NTTQAVK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ve_chain_green.jpg?v=1746043310	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	3	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZP6Q3SC3CV3RNMD3JB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7626.jpg?v=1746043310	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	4	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZP2F0RBMPM92JMZ51W	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5839_1.jpg?v=1746043310	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	5	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZQ4H943741N7ZEQW8K	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8526_1.jpg?v=1746043310	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	6	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZQ4ZXFBTN5MC55A5X2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/red.jpg?v=1746122787	\N	2026-08-04 12:36:49.494+00	2026-08-04 12:36:49.494+00	\N	7	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZQ503W0RV9SNMZ94F1	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_2878.jpg?v=1746043310	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	8	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZQHBX3YWM64GJ79Y8A	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-02h24m58s359.png?v=1746122787	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	9	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZQ6JVPJS0PDPECXMNF	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5858.jpg?v=1746122787	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	10	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZRJKQA2MFRHJGTAXY2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1-2_a7a85ddd-27b0-439e-83e8-19ec5984f07b.jpg?v=1746122787	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	11	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZRGQQVX80DCWPD3ZDB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5197.png?v=1746122787	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	12	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZR2SYA4K7WTQ17EP8N	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8534_1.jpg?v=1746122787	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	13	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZR7BGK3N7HCFPYN724	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-16-14h43m48s507.jpg?v=1746122787	\N	2026-08-04 12:36:49.495+00	2026-08-04 12:36:49.495+00	\N	14	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZS1FXCGES6GTFZ5Z3T	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5030.jpg?v=1746122787	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	15	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZSF7AJM3X7S0RMVNAE	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5841_1.jpg?v=1746122787	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	16	prod_01KZ6CDKYPDQG0QDKT37MDDPA3
img_01KZ6CDKZSJCTJ542JVV8JDY3X	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/cherry1.jpg?v=1749327131	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	0	prod_01KZ6CDKYPP489B1SJAPJ484NC
img_01KZ6CDKZT1S597P086GWB9J1X	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-19-21h21m53s521.png?v=1749327131	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	1	prod_01KZ6CDKYPP489B1SJAPJ484NC
img_01KZ6CDKZTGXGDPGBFVXCQZCCK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5951.jpg?v=1749327131	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	2	prod_01KZ6CDKYPP489B1SJAPJ484NC
img_01KZ6CDKZT3ZXPP14DF2VW56TK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-11-16-20h30m05s522.jpg?v=1749327131	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	3	prod_01KZ6CDKYPP489B1SJAPJ484NC
img_01KZ6CDKZVE4XNT88HJTKEYV9X	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_May_9_2025_12_05_00_AM.jpg?v=1747321638	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	0	prod_01KZ6CDKYP0NXWRGS0S9F7YK07
img_01KZ6CDKZV6PSZ9W3G0RQQ1GGC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/c2.jpg?v=1750286373	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	1	prod_01KZ6CDKYP0NXWRGS0S9F7YK07
img_01KZ6CDKZV592WDVD23WX4CW29	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ce3.jpg?v=1753466706	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	2	prod_01KZ6CDKYP0NXWRGS0S9F7YK07
img_01KZ6CDKZV0QP5E731B1ZR263J	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ce6.jpg?v=1753466706	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	3	prod_01KZ6CDKYP0NXWRGS0S9F7YK07
img_01KZ6CDKZWJR07T5DHYW7ZKB3R	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/c4.jpg?v=1753466706	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	4	prod_01KZ6CDKYP0NXWRGS0S9F7YK07
img_01KZ6CDKZWY6JJSS3N84K2C5C1	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/c3.jpg?v=1753466706	\N	2026-08-04 12:36:49.496+00	2026-08-04 12:36:49.496+00	\N	5	prod_01KZ6CDKYP0NXWRGS0S9F7YK07
img_01KZ6CDKZWQ5R4V0PAWVQGFC3B	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-08-01h06m12s468.jpg?v=1736279422	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	0	prod_01KZ6CDKYP8TPBAEBKDNYT69V1
img_01KZ6CDKZXF2B3Y2SWRB3ZGFQA	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-08-01h11m28s779.png?v=1736279422	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	1	prod_01KZ6CDKYP8TPBAEBKDNYT69V1
img_01KZ6CDKZXCR0V07KEVJT9KQ53	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-08-01h05m33s841.jpg?v=1736279422	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	2	prod_01KZ6CDKYP8TPBAEBKDNYT69V1
img_01KZ6CDKZXGJPJNW5CYPR26M0H	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-08-01h10m10s961.png?v=1736279342	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	3	prod_01KZ6CDKYP8TPBAEBKDNYT69V1
img_01KZ6CDKZXJHXJ9F7ZYX48E9YJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8482.jpg?v=1734460059	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	0	prod_01KZ6CDKYQZYC4BQ53JRC9CSD8
img_01KZ6CDKZY77P28F06T7W66SSA	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_6475.jpg?v=1734460059	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	1	prod_01KZ6CDKYQZYC4BQ53JRC9CSD8
img_01KZ6CDKZYZVBT9FX4RDZXZ5ZN	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_07a38ece-9c85-48c7-9b83-4b978b137ec8.webp?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	0	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDKZY0AKANQJX2R2FTGJP	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_b6acb37e-ba76-4f37-b4d3-199f917c0d72.jpg?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	1	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDKZZNRBW3RBP4MNRH08E	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/6_54c2466b-fb8f-4b55-b65a-4bf71b8eedba.jpg?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	2	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDKZZZGF4KJ7A6WQD6V21	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_33075190-e80b-453e-aec0-d48bd8386a48.jpg?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	3	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDKZZEFAR9J0MSP5TKXQK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/4_4479f1c9-9cf7-4872-a6a7-56f802225a2f.jpg?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	4	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDKZZB89EZ0DHHW1PY8BE	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/5_0d77d08c-1795-43bb-9cfe-5212386d7085.jpg?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	5	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDKZZD9EANV7N1PFMW6PH	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_f73f8a0d-bb54-45f3-be2e-b68a69e0418a.jpg?v=1734460237	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	6	prod_01KZ6CDKYQR48K72DFGE82BV0X
img_01KZ6CDM00QH9Y0ZH5KGBP61RW	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_51c547ef-eeb5-40bb-a6d9-015ebab3f4b1.jpg?v=1711834066	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	0	prod_01KZ6CDKYQA9WY630Q6ZQAHXAY
img_01KZ6CDM00Z3R3FZ5JA4M0XCZW	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_66391fd1-81ce-475b-810f-9ee49a3af7e0.jpg?v=1711834066	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	1	prod_01KZ6CDKYQA9WY630Q6ZQAHXAY
img_01KZ6CDM01H88J4X62T6TBXYY9	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1539.jpg?v=1742232482	\N	2026-08-04 12:36:49.497+00	2026-08-04 12:36:49.497+00	\N	0	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM020S18GHF39QN19KXF	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1547.jpg?v=1742232482	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	1	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM020RAYQ2SMTT3VZH1P	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1546.jpg?v=1742288766	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	2	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM02FSR15Z9H12AYR9Y0	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_1.jpg?v=1742232482	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	3	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM02PHGZPHPRQ85MS7RR	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_3.jpg?v=1742288766	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	4	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM0310WZB3F1RRZ75XP6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_2.jpg?v=1742288766	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	5	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM0338K2P6NKR4GT7HKQ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1545.jpg?v=1742288766	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	6	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W
img_01KZ6CDM03P6D905PJVZFYP1Z2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-31-00h21m24s584.jpg?v=1738264450	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	0	prod_01KZ6CDKYRZ215S2ACPC8ER0DH
img_01KZ6CDM04J6C3TE37JPWZG4GW	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-31-00h23m31s546.jpg?v=1738264481	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	1	prod_01KZ6CDKYRZ215S2ACPC8ER0DH
img_01KZ6CDM045PJ6NX53QN8CTYCS	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-31-00h22m39s151.jpg?v=1738264481	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	2	prod_01KZ6CDKYRZ215S2ACPC8ER0DH
img_01KZ6CDM04NQ02DX8RJFX9RP5Q	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-31-00h21m31s803.jpg?v=1738264481	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	3	prod_01KZ6CDKYRZ215S2ACPC8ER0DH
img_01KZ6CDM052EPRFXN6DJYEVNTJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-31-00h23m26s318.jpg?v=1738264481	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	4	prod_01KZ6CDKYRZ215S2ACPC8ER0DH
img_01KZ6CDM054NAG2NHXXHHEB71Y	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/f1.jpg?v=1747324240	\N	2026-08-04 12:36:49.498+00	2026-08-04 12:36:49.498+00	\N	0	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM060HRB2HJZ4NSWAWVJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/f6.jpg?v=1747324240	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	1	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM069W6QM0RKJQ949ADW	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0947-2.jpg?v=1747324240	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	2	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM06D10H51SGZETKNX5H	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0939.jpg?v=1747324240	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	3	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM06DEF8X172CRTNGY7B	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0938.jpg?v=1747324108	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	4	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM07MZF1X1Z5VJ1AYXRV	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0940.jpg?v=1747324108	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	5	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM09BE6YVPVGMWQ0Y0KC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0941.jpg?v=1747324108	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	6	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM0AZEEYVTP2VZ0Z2E63	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0942.jpg?v=1747324108	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	7	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM0AVVQWX1MMS319K9A6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0943.jpg?v=1747324108	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.499+00	\N	8	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM0APPFA3ZHK73B9HHPC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0944.jpg?v=1747324108	\N	2026-08-04 12:36:49.499+00	2026-08-04 12:36:49.5+00	\N	9	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM0AXQQY283244RGV5XC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0945.jpg?v=1747324108	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	10	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM0B3QDAEBGT4QK7S50J	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_0946.jpg?v=1747324108	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	11	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1
img_01KZ6CDM0CD3V1P2GHZW7PQPQQ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-20h35m40s196-2.jpg?v=1734460042	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	0	prod_01KZ6CDKYR72K3JFDD9WRHXFMP
img_01KZ6CDM0CYHWHR5PY6NSHQKKX	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-20h40m16s308.jpg?v=1734460042	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	1	prod_01KZ6CDKYR72K3JFDD9WRHXFMP
img_01KZ6CDM0CC0EFGEVNNV3N1CC2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-20h40m25s434.jpg?v=1734460042	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	2	prod_01KZ6CDKYR72K3JFDD9WRHXFMP
img_01KZ6CDM0DH0YYGZK9DFQFGY6N	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5925.jpg?v=1732091778	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	0	prod_01KZ6CDKYR6NPKX84Y57F84V1Q
img_01KZ6CDM0EC4S3F9GCR754A8XW	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5811.jpg?v=1732091731	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	1	prod_01KZ6CDKYR6NPKX84Y57F84V1Q
img_01KZ6CDM0EJFZ9PQW680TT5G1W	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5928.jpg?v=1732091731	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	2	prod_01KZ6CDKYR6NPKX84Y57F84V1Q
img_01KZ6CDM0FTVCFQC9DHM37ZTD7	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_e92b5ed0-dd03-4db3-9577-5db03502b0b4.jpg?v=1717249044	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	0	prod_01KZ6CDKYS41JESCZCY4BCM9FM
img_01KZ6CDM0FVVMVF5N8CQ80VGTR	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_dc805098-5d87-4347-bdff-7046931989cb.jpg?v=1717249044	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	1	prod_01KZ6CDKYS41JESCZCY4BCM9FM
img_01KZ6CDM0FBC8A2DSZ3WPTCHGE	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_5f6d20e5-1c80-40ce-a272-872503a641bf.jpg?v=1717249166	\N	2026-08-04 12:36:49.5+00	2026-08-04 12:36:49.5+00	\N	2	prod_01KZ6CDKYS41JESCZCY4BCM9FM
img_01KZ6CDM0GCGBCS60JNRBCMXS2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Express-collage_2.png?v=1728068544	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	0	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B
img_01KZ6CDM0GV5QP8RPVJQWY8M43	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_4697ab8a-a626-4c39-8b3f-9ade45f2bd38.jpg?v=1726086867	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	1	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B
img_01KZ6CDM0HQ91XKHN7PY2AG5X9	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-02h26m00s932_845c87cc-e316-4857-a4c7-83aa39f8a7e1.png?v=1728068522	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	2	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B
img_01KZ6CDM0H67Q65E1AHYR50W18	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-02h27m20s424.png?v=1728068521	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	3	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B
img_01KZ6CDM0HKD7DVHZ357VRHKAX	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-02h24m58s359.png?v=1746122787	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	4	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B
img_01KZ6CDM0HF73EFFJBR8NQDFNQ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-02h24m30s971_b1d25bad-7f6c-4831-989f-1bf9abbc4994.png?v=1728068394	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	5	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B
img_01KZ6CDM0JPZRWK4G8527ATDX0	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/hm2.jpg?v=1748473116	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	0	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0J6A9SH37VAHCN8H9M	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1560.jpg?v=1748516798	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	1	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0KGE8NQC4CD020SXTW	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1559.jpg?v=1748473116	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	2	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0K2TVE4RT5E4DTY3ME	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/hm4.jpg?v=1748516798	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	3	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0K7XHTAZCWT46FM8KS	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/hm3.jpg?v=1748516798	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	4	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0MM2ARF4N3MNQ7M5TC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1562.jpg?v=1748516798	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	5	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0MKV9248Y4VEDGTMD2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1563.jpg?v=1748516798	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	6	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0NMTB8RSNSGWA8TGVM	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1565.jpg?v=1748516798	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	7	prod_01KZ6CDKYST01Z3CFZ1PXH5C76
img_01KZ6CDM0N9XK9VP9BHE37GVE4	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1-2.jpg?v=1725918446	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	0	prod_01KZ6CDKYSH709KDZ998WH03F7
img_01KZ6CDM0Q4J7J8DRM5KBJZ17F	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_12d089b0-ac5f-4feb-9e5f-c4da4b01d1c6.jpg?v=1725917226	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	1	prod_01KZ6CDKYSH709KDZ998WH03F7
img_01KZ6CDM0QJYSP5AB69T3KJJG1	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_a8a26d03-30ee-4d66-a93f-e5a02f3c4b7e.jpg?v=1725917300	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.501+00	\N	2	prod_01KZ6CDKYSH709KDZ998WH03F7
img_01KZ6CDM0RYDS9TSWTCRV99HG5	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8859.heic?v=1725877127	\N	2026-08-04 12:36:49.501+00	2026-08-04 12:36:49.502+00	\N	3	prod_01KZ6CDKYSH709KDZ998WH03F7
img_01KZ6CDM0SA2CSCCYNAQ3ZXHS8	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1531.jpg?v=1744478357	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	0	prod_01KZ6CDKYSHC0QM80WW9BRKDEN
img_01KZ6CDM0SPNHWM03JDVC2Z4H3	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1528.jpg?v=1744478357	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	1	prod_01KZ6CDKYSHC0QM80WW9BRKDEN
img_01KZ6CDM0SXZTVMT99AAA1BTJN	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1534.jpg?v=1744478141	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	2	prod_01KZ6CDKYSHC0QM80WW9BRKDEN
img_01KZ6CDM0T7PR6ZHNM66DF7X68	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/mas.jpg?v=1725914277	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	0	prod_01KZ6CDKYT1JZ4CFG3QV6M39SC
img_01KZ6CDM0VR2139DCS3GPVTM57	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-01h23m26s965.png?v=1725915133	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	1	prod_01KZ6CDKYT1JZ4CFG3QV6M39SC
img_01KZ6CDM0VZFT7NRGD05FB2R7H	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-21h05m41s696-2.jpg?v=1734450890	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	0	prod_01KZ6CDKYTAQ19H3S7SES4WHV4
img_01KZ6CDM0WPBS0DQCG7KTTDCQ2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-21h06m02s690.jpg?v=1734450890	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	1	prod_01KZ6CDKYTAQ19H3S7SES4WHV4
img_01KZ6CDM0W8C06RG3YEWWGZ1S4	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-21h06m38s487.jpg?v=1734450890	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	2	prod_01KZ6CDKYTAQ19H3S7SES4WHV4
img_01KZ6CDM0X9G2PCFBRWP7PSZEQ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5224.jpg?v=1760969116	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	0	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT
img_01KZ6CDM0Y5TVNZF30CHH2TX5D	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-19-21h00m54s272.png?v=1760969116	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	1	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT
img_01KZ6CDM0Y26EM8JAMW0DDAJA6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2025-10-02_at_12.54.36_PM_1.jpg?v=1760969116	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	2	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT
img_01KZ6CDM0YDMD932WVNBD49DN0	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-19-21h00m58s112.png?v=1760969116	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	3	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT
img_01KZ6CDM0ZY3YZ3K3TQCR2AQPR	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-19-21h01m27s437.png?v=1760969116	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	4	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT
img_01KZ6CDM0Z4BP07MKPEP1RDD5C	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2025-10-02_at_12.54.27_PM.jpg?v=1760967808	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	5	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT
img_01KZ6CDM10GZRTEKHBSFEJBKE1	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7675.jpg?v=1732801204	\N	2026-08-04 12:36:49.502+00	2026-08-04 12:36:49.502+00	\N	0	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW
img_01KZ6CDM1057T0JQYV2PY0A757	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3800.heic?v=1726362149	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	1	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW
img_01KZ6CDM11RDY9XNQE4A9DZYRY	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3779.heic?v=1726361929	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	2	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW
img_01KZ6CDM112Y6RN4CY38YAHCDT	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5244.jpg?v=1732801203	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	3	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW
img_01KZ6CDM11KADJ7ERYSPEYV0P9	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5248.jpg?v=1732801204	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	4	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW
img_01KZ6CDM12KFD5XDDY4NG1VRAP	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ocean_drop_blue_pendant.jpg?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	0	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM12XA62GJRJWXZ60K13	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h27m51s977.png?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	1	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM13BFCVZWT4BKJJWNTZ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8512.jpg?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	2	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM1313EN721DPDHXVBVD	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_0af11752-1942-43e6-8e93-9c01c45c1f7f.jpg?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	3	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM138187CJYD82VH75FY	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h28m58s548.png?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	4	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM14FE66QFRJ828EYD68	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h27m42s991.png?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	5	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM147TTCVX1TM3JJ3V29	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h28m18s451.png?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	6	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM15ZDMN8KRG0QRBPA0G	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h29m04s545.png?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	7	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM15TP3DT9WZT2GJS1PP	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h27m59s159.jpg?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	8	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM15NG0Z7T4KM3MXD6C5	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-13-00h27m55s007.png?v=1754695786	\N	2026-08-04 12:36:49.503+00	2026-08-04 12:36:49.503+00	\N	9	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM15ZF6XRT4PV54DBRXM	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5045.png?v=1754695786	\N	2026-08-04 12:36:49.504+00	2026-08-04 12:36:49.504+00	\N	10	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM16XPP7411WQ0BJRVVE	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5060.png?v=1754695786	\N	2026-08-04 12:36:49.504+00	2026-08-04 12:36:49.504+00	\N	11	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM167FDMKGVSQXWVW18E	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1263.jpg?v=1754695515	\N	2026-08-04 12:36:49.504+00	2026-08-04 12:36:49.504+00	\N	12	prod_01KZ6CDKYVVCPP054QV0XAZGXF
img_01KZ6CDM17P5TY7FS3B17BN5Y4	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-13-14h17m49s649.jpg?v=1726222740	\N	2026-08-04 12:36:49.504+00	2026-08-04 12:36:49.504+00	\N	0	prod_01KZ6CDKYVSGW61NNZPD4KXBWY
img_01KZ6CDM18YK4TZAK3FG6SF5M2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-13-15h21m30s599.jpg?v=1726222741	\N	2026-08-04 12:36:49.504+00	2026-08-04 12:36:49.504+00	\N	1	prod_01KZ6CDKYVSGW61NNZPD4KXBWY
img_01KZ6CDM19GSK83F02B0HGFBH8	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_9167.jpg?v=1760973405	\N	2026-08-04 12:36:49.504+00	2026-08-04 12:36:49.505+00	\N	0	prod_01KZ6CDKYW57VVJNPN63K17BJQ
img_01KZ6CDM19JK2RRTV1QBF28K09	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-11-28-19h16m18s615.png?v=1760973405	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	1	prod_01KZ6CDKYW57VVJNPN63K17BJQ
img_01KZ6CDM1ATN2PHJM0EXJS1BXQ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_9165.jpg?v=1760973405	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	2	prod_01KZ6CDKYW57VVJNPN63K17BJQ
img_01KZ6CDM1AE81QZVTBMVP4G3BE	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsAppImage2024-11-27at8.35.10PM.jpg?v=1760973405	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	3	prod_01KZ6CDKYW57VVJNPN63K17BJQ
img_01KZ6CDM1BX0BPGTRBD4STT21B	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsAppImage2024-11-27at8.35.11PM.jpg?v=1760973405	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	4	prod_01KZ6CDKYW57VVJNPN63K17BJQ
img_01KZ6CDM1BY59HR40K2VKMPEVG	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-11-28-19h16m33s549.png?v=1760973405	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	5	prod_01KZ6CDKYW57VVJNPN63K17BJQ
img_01KZ6CDM1CF2E0F9P7VFDGF9P6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7092_1.jpg?v=1753031411	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	0	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1DMAJM9XPYPZMVTW98	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7078.jpg?v=1753031322	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	1	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1DC9H03X5HJZDT78R6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7073.jpg?v=1753031322	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	2	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1EH3VCC3Y4RXB0J1NK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7093.jpg?v=1753031322	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	3	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1ES8G6XPW4K6K51BMB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7082.jpg?v=1753031322	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	4	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1F4KWN6A67N10FXJ6F	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_3f4dc4cb-a186-41e6-824e-7bdffbcfc8b1.jpg?v=1753031322	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	5	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1QQAEDJH2ND1GMSN46	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_55c268a5-d6e7-4252-9234-9348cf61b6c6.jpg?v=1753031322	\N	2026-08-04 12:36:49.505+00	2026-08-04 12:36:49.505+00	\N	6	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1RQPGFM8CNEBJXQ3RV	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_664f073f-9f26-4c89-9ab5-cb4b14905307.jpg?v=1753031322	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	7	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1SE8W9JG8Y2A6NRR0V	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7087.jpg?v=1753031322	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	8	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ
img_01KZ6CDM1TAG2R0MY79829AX2Y	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-30-04h36m06s240.png?v=1727651270	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	0	prod_01KZ6CDKYXXTR7F86BCCC30ZR7
img_01KZ6CDM1VF54WXSV7RN4MN342	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1459_40e95d40-7403-4b0f-86b9-7be13311b143.jpg?v=1726609188	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	0	prod_01KZ6CDKYX8WKS0VK0PA1MEV6X
img_01KZ6CDM1VY06WH5NX0JKG5N4E	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2024-09-12_at_5.08.46_PM.jpg?v=1726607478	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	1	prod_01KZ6CDKYX8WKS0VK0PA1MEV6X
img_01KZ6CDM1WAV49NJSF6BFWHTT9	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_7b9bb060-2b71-417b-8b07-c3e5e61c71e7.jpg?v=1717249512	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	0	prod_01KZ6CDKYY4A5TBFR2ETW7PBKE
img_01KZ6CDM1XKA5ASF5Q3TSJWZ92	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_591ea595-aec2-48df-ab70-3ad6b12e94e3.jpg?v=1717249457	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	1	prod_01KZ6CDKYY4A5TBFR2ETW7PBKE
img_01KZ6CDM1YHKVR55GP4KAZDPNH	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_f32dd844-2712-4e7b-bdce-9f9fafaedc1b.jpg?v=1717249422	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	0	prod_01KZ6CDKYY274F77R2WV1ZVGCH
img_01KZ6CDM1YEP8C1C2YJSF27BMD	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_591ea595-aec2-48df-ab70-3ad6b12e94e3.jpg?v=1717249457	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	1	prod_01KZ6CDKYY274F77R2WV1ZVGCH
img_01KZ6CDM1ZDHQD5GCHZAJGKFCC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_cfd39683-8334-4767-820b-23da5cd38b22.jpg?v=1717246461	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	0	prod_01KZ6CDKYY82VSC9VRBD393XVG
img_01KZ6CDM20Z1MR1E2TRW58TS2P	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/4_e29ade10-649f-445a-a459-784c669009f5.jpg?v=1717246471	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	1	prod_01KZ6CDKYY82VSC9VRBD393XVG
img_01KZ6CDM20DZ3KE177MGXMPWV2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_7fcc0f1b-c795-467d-a3ec-af6b310759e6.jpg?v=1717246471	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	2	prod_01KZ6CDKYY82VSC9VRBD393XVG
img_01KZ6CDM208JTV9G7T13JAY4QY	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_af59a74f-9668-4c49-973d-26a5106dea09.jpg?v=1717246471	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	3	prod_01KZ6CDKYY82VSC9VRBD393XVG
img_01KZ6CDM22B9YZF8VEH9TDBTN8	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1460.jpg?v=1745090433	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	0	prod_01KZ6CDKYYSXAKPSQNKY2A7W55
img_01KZ6CDM22WRQAX9SN6D21Y46A	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_4888.png?v=1745090433	\N	2026-08-04 12:36:49.506+00	2026-08-04 12:36:49.506+00	\N	1	prod_01KZ6CDKYYSXAKPSQNKY2A7W55
img_01KZ6CDM23AXQ0PYP35XRDC2W6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2025-06-24_at_1.12.19_PM.jpg?v=1750753736	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	2	prod_01KZ6CDKYYSXAKPSQNKY2A7W55
img_01KZ6CDM23KGP0J6MFZ5N1G3X2	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-11-03-04h08m54s833.png?v=1750753736	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	3	prod_01KZ6CDKYYSXAKPSQNKY2A7W55
img_01KZ6CDM245RH3DJCVTYH3TZWC	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_4996.png?v=1750753736	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	4	prod_01KZ6CDKYYSXAKPSQNKY2A7W55
img_01KZ6CDM252Z6KX8MYPF5TVYR3	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_4902.png?v=1750753736	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	5	prod_01KZ6CDKYYSXAKPSQNKY2A7W55
img_01KZ6CDM27Q8QRH6X05ZC8QJT9	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-02-19-19h39m28s429.jpg?v=1739977337	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	0	prod_01KZ6CDKYYR42B0PEP10Y3FT52
img_01KZ6CDM28GMRF6JYSQ8F500BJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-02-19-19h38m27s720.jpg?v=1739977337	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	1	prod_01KZ6CDKYYR42B0PEP10Y3FT52
img_01KZ6CDM2ABF3QHC9Z8Z7CY0PB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-02-19-19h38m11s116-3.jpg?v=1739977329	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	2	prod_01KZ6CDKYYR42B0PEP10Y3FT52
img_01KZ6CDM2B6R954YW5R1KB5FSX	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-02-19-19h38m19s065.jpg?v=1739977329	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	3	prod_01KZ6CDKYYR42B0PEP10Y3FT52
img_01KZ6CDM2BTHM51FC56K4TY2V8	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3832.jpg?v=1739977321	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	4	prod_01KZ6CDKYYR42B0PEP10Y3FT52
img_01KZ6CDM2C4E0DH3CVXBE11N4J	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7756.jpg?v=1732804986	\N	2026-08-04 12:36:49.507+00	2026-08-04 12:36:49.507+00	\N	0	prod_01KZ6CDKYZYWXF8070GY5M3PCS
img_01KZ6CDM2E4DZ4N83H11MFJ9CY	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7766.jpg?v=1732804986	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	1	prod_01KZ6CDKYZYWXF8070GY5M3PCS
img_01KZ6CDM2FX3T7A0TZ36WA1TA4	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ss4.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	0	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2FMGW6XNP1FAQFGXBB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ss2.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	1	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2G5XAS7ZJGNNJV68VY	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3222.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	2	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2HYKQK39XWY5DSMTD5	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ss3.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	3	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2JVRWM2NRGBEET031V	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3223.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	4	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2KP5XRNBSSKX1Y0DRV	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ss1.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	5	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2KJGJEPXET1D2Y1CKN	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3224.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	6	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2MCN3DXJYZY15SEEP0	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3226.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	7	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2NG49V64ESBFP3EDHH	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3227.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	8	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2P4TDVHKVP9T7T3SZ6	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3228.jpg?v=1747321364	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	9	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F
img_01KZ6CDM2R6HPCQKK5Y6ZD8J3H	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_May_20_2025_01_58_38_PM.png?v=1754222174	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	0	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB
img_01KZ6CDM2S5SZDZBMMZFKJJQHS	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-12-02h43m18s237.png?v=1754222174	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	1	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB
img_01KZ6CDM2TSKXQE18WXKVWDKYK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_May_20_2025_02_04_01_PM.png?v=1754222174	\N	2026-08-04 12:36:49.508+00	2026-08-04 12:36:49.508+00	\N	2	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB
img_01KZ6CDM2V87NDCKNHFA89CXW7	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-12-02h43m31s044.png?v=1754222174	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	3	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB
img_01KZ6CDM2VJVESVT3YNAW5EEF4	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-12-02h43m53s503.png?v=1754222174	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	4	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB
img_01KZ6CDM2Y94G1BHN9RXKX7PFT	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-11-02h26m31s497.jpg?v=1739973635	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	0	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF
img_01KZ6CDM2ZVEP5WD5Z4GATPSPF	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_3181.jpg?v=1739973613	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	1	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF
img_01KZ6CDM2Z9WG9A9PMDVZG8VPA	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2024-09-19_at_9.35.35_AM_2.jpg?v=1739973575	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	2	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF
img_01KZ6CDM31JRBWW0BV02XE2G2E	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1982_2.heic?v=1739973575	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	3	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF
img_01KZ6CDM314JJB2FMYEZTKKSSJ	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5187.png?v=1730328775	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	4	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF
img_01KZ6CDM3294QPJX7AFWEXVM52	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_4dd2ebaa-6042-4622-80de-d06cd2f1e521.jpg?v=1726002955	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	5	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF
img_01KZ6CDM33T4C3HVP2M2SA0D5X	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_9119.jpg?v=1766521702	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68
img_01KZ6CDM34NQ3DRAHAJ4NKHDW3	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-16-14h29m10s671.png?v=1766521702	\N	2026-08-04 12:36:49.509+00	2026-08-04 12:36:49.509+00	\N	1	prod_01KZ6CDKZ018SVF05RXG350H68
img_01KZ6CDM34KH877MMBPSZDNJ4J	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-16-14h29m17s799.png?v=1766521702	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	2	prod_01KZ6CDKZ018SVF05RXG350H68
img_01KZ6CDM35MKPRVDTP1KRK9YY1	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-16-14h43m38s369-2.jpg?v=1766521702	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	3	prod_01KZ6CDKZ018SVF05RXG350H68
img_01KZ6CDM3632FNPX7F1X1KTKE5	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_b9b5a05a-0d4c-48d7-b213-413ca97f0d51.jpg?v=1717246550	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	0	prod_01KZ6CDKZ0H2CPWHX4YDE9MWCM
img_01KZ6CDM36T5AJ0XVV44HX9MCH	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_ca54b85d-308e-43e6-8b38-375383168ac5.jpg?v=1717246550	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	1	prod_01KZ6CDKZ0H2CPWHX4YDE9MWCM
img_01KZ6CDM37HB43P0XRS9A3Y655	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_Apr_21_2025_11_07_57_PM.png?v=1745260814	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM38TSNS8CEVN5X9769K	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_Apr_22_2025_01_48_11_AM.png?v=1745266873	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	1	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM388FWVH9JZVAVE9420	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-02h24m30s971.png?v=1745266873	\N	2026-08-04 12:36:49.51+00	2026-08-04 12:36:49.51+00	\N	2	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM38TQ95S1QM38P8QBVG	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_6ea1d9ea-c712-4407-bfac-0ea9a8abf22c.jpg?v=1745266873	\N	2026-08-04 12:36:49.511+00	2026-08-04 12:36:49.511+00	\N	3	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM397J21C7JSMN7DVDR5	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1352.jpg?v=1745266873	\N	2026-08-04 12:36:49.511+00	2026-08-04 12:36:49.511+00	\N	4	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM39EGZNW7VDW2KR19S7	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5228.png?v=1745266873	\N	2026-08-04 12:36:49.511+00	2026-08-04 12:36:49.511+00	\N	5	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3AV3FNM9WY0YMRG7N5	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5029_1.jpg?v=1745266873	\N	2026-08-04 12:36:49.511+00	2026-08-04 12:36:49.511+00	\N	6	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3BSNK86B2NGB0CNS6J	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1338.jpg?v=1745266873	\N	2026-08-04 12:36:49.511+00	2026-08-04 12:36:49.511+00	\N	7	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3C4TDV64GRK2YQ51RV	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5261.png?v=1745266873	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	8	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3CYKBZHM3VQY2TPS92	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_9d0681dd-fec0-4e5f-86f8-b78079c10652.jpg?v=1745266873	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	9	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3DC0BT06DN4BNE7J81	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_May_19_2025_10_50_26_PM.png?v=1747676245	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	10	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3EH7BDF8NEW3FQEF50	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-10-03h29m42s627.png?v=1745266873	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	11	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN
img_01KZ6CDM3GRJDWGPPN2BRVF8SK	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1880.jpg?v=1745089488	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	0	prod_01KZ6CDKZ0ZYP65PJVX991FY70
img_01KZ6CDM3H5Y2ZQY1J3WT8HT72	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1882.jpg?v=1745089489	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	1	prod_01KZ6CDKZ0ZYP65PJVX991FY70
img_01KZ6CDM3J4RFP7AQRPZ0K5X08	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1885.jpg?v=1745089488	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	2	prod_01KZ6CDKZ0ZYP65PJVX991FY70
img_01KZ6CDM3K2ZHBCY5NKDPHMB1Z	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Express-collage_1.png?v=1728068006	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	0	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM
img_01KZ6CDM3M2YY63GGMDX3BEB34	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Screenshot2024-10-04at20-58-58VeChain_Strawb.png?v=1728056054	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	1	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM
img_01KZ6CDM3N41ZJS8EKVPNH2ZWB	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-30-04h36m06s240.png?v=1727651270	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	2	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM
img_01KZ6CDM3NENAX9ZPC9HF74W53	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-10-04-21h03m14s468.png?v=1728056208	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	3	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM
img_01KZ6CDM3PNR8K8Y4ZPCK9QDXA	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-10-04-21h04m00s433.png?v=1728056181	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	4	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM
img_01KZ6CDM3QPBFJBBK2KV1VRQGF	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7879.jpg?v=1753033466	\N	2026-08-04 12:36:49.512+00	2026-08-04 12:36:49.512+00	\N	0	prod_01KZ6CDKZ1921PDG5W42Z4XBA6
img_01KZ6CDM3RAVA0S8J44CS544V7	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7905.jpg?v=1753033466	\N	2026-08-04 12:36:49.513+00	2026-08-04 12:36:49.513+00	\N	1	prod_01KZ6CDKZ1921PDG5W42Z4XBA6
img_01KZ6CDM3RH43VKBSHZKKPQ19J	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8020.jpg?v=1753033466	\N	2026-08-04 12:36:49.513+00	2026-08-04 12:36:49.513+00	\N	2	prod_01KZ6CDKZ1921PDG5W42Z4XBA6
img_01KZ6CDM3RK72B3T12WWF4Q5J3	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7904_84722192-dec2-4365-8f69-57df6eaf412f.jpg?v=1753033262	\N	2026-08-04 12:36:49.513+00	2026-08-04 12:36:49.513+00	\N	3	prod_01KZ6CDKZ1921PDG5W42Z4XBA6
img_01KZ4ZY9GTMM0ACNVH0PA1Z5JA	http://localhost:9000/static/1785800369490-WIN_20260719_02_55_48_Pro.jpg	\N	2026-08-03 23:39:29.755+00	2026-08-04 12:40:32.46+00	2026-08-04 12:40:32.415+00	0	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW
img_01KZ4ZY9GVTHMVKA32XAWMVPXC	http://localhost:9000/static/1785800369494-WIN_20260719_02_55_58_Pro.jpg	\N	2026-08-03 23:39:29.755+00	2026-08-04 12:40:32.462+00	2026-08-04 12:40:32.415+00	1	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW
img_01KZ4ZY9GWYY6G48EWM37KMM7N	http://localhost:9000/static/1785800369499-WIN_20260719_02_58_01_Pro.jpg	\N	2026-08-03 23:39:29.756+00	2026-08-04 12:40:32.462+00	2026-08-04 12:40:32.415+00	2	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW
img_01KZ4ZY9GY7CE2YGBFCVXVTBFE	http://localhost:9000/static/1785800369507-WIN_20251012_21_25_31_Pro.jpg	\N	2026-08-03 23:39:29.756+00	2026-08-04 12:40:32.462+00	2026-08-04 12:40:32.415+00	3	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW
nsbws8	http://localhost:9000/static/1785801225241-WIN_20260719_03_05_53_Pro.jpg	\N	2026-08-03 23:53:45.48+00	2026-08-04 12:40:32.462+00	2026-08-04 12:40:32.415+00	4	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW
gsd7	http://localhost:9000/static/1785801225243-WIN_20260719_03_05_47_Pro.jpg	\N	2026-08-03 23:53:45.48+00	2026-08-04 12:40:32.462+00	2026-08-04 12:40:32.415+00	5	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW
img_01KZ6WJVEGWTJWWWBV247SEQDN	http://localhost:9000/static/1785863957932-IMG_4259.jpg	\N	2026-08-04 17:19:17.97+00	2026-08-04 17:19:17.97+00	\N	0	prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ
img_01KZ6WJVEGCPS8CAGFVVKKB97G	http://localhost:9000/static/1785863957934-IMG_4248_0579babe-50e4-4ba0-8768-21388aaf3c6b.jpg	\N	2026-08-04 17:19:17.97+00	2026-08-04 17:19:17.97+00	\N	1	prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ
yhi0g	http://localhost:9000/static/1785865606231-q1.jpg	\N	2026-08-04 17:46:46.333+00	2026-08-04 17:46:46.333+00	\N	0	prod_01KZ6Y4FTH912SHCT626EJW0XS
mst6en	http://localhost:9000/static/1785865606233-q2.jpg	\N	2026-08-04 17:46:46.333+00	2026-08-04 17:46:46.333+00	\N	1	prod_01KZ6Y4FTH912SHCT626EJW0XS
oj8s5j	http://localhost:9000/static/1785865606236-q3.jpg	\N	2026-08-04 17:46:46.333+00	2026-08-04 17:46:46.333+00	\N	2	prod_01KZ6Y4FTH912SHCT626EJW0XS
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01KZ6CDN5NZ4RP94G6VXART3VD	2026-08-04 12:36:50.522+00	2026-08-04 12:36:50.522+00	\N	And Forever - gold	\N	\N	\N	\N	0	\N	\N	\N	t	And Forever - gold	And Forever - gold	\N	\N
iitem_01KZ6CDN5N7VTJQZGQT8HN5GCJ	2026-08-04 12:36:50.522+00	2026-08-04 12:36:50.522+00	\N	And Forever - silver	\N	\N	\N	\N	0	\N	\N	\N	t	And Forever - silver	And Forever - silver	\N	\N
iitem_01KZ6CDN5PCJQ3R6VDXVY58T88	2026-08-04 12:36:50.522+00	2026-08-04 12:36:50.522+00	\N	khdz004	\N	\N	\N	\N	0	\N	\N	\N	t	khdz004	khdz004	\N	\N
iitem_01KZ6CDN5RZ3F70629H3ENNNS1	2026-08-04 12:36:50.523+00	2026-08-04 12:36:50.523+00	\N	Blingers - gold	\N	\N	\N	\N	0	\N	\N	\N	t	Blingers - gold	Blingers - gold	\N	\N
iitem_01KZ6CDN5RZ2R108GNBAEXQRR5	2026-08-04 12:36:50.523+00	2026-08-04 12:36:50.523+00	\N	Blingers - silver	\N	\N	\N	\N	0	\N	\N	\N	t	Blingers - silver	Blingers - silver	\N	\N
iitem_01KZ6CDN5T48SRXRFNZFPJHYYS	2026-08-04 12:36:50.523+00	2026-08-04 12:36:50.523+00	\N	buckle up	\N	\N	\N	\N	0	\N	\N	\N	t	buckle up	buckle up	\N	\N
iitem_01KZ6CDN5T5AVGH0TFRV1TM50F	2026-08-04 12:36:50.523+00	2026-08-04 12:36:50.523+00	\N	Butterflies - gold	\N	\N	\N	\N	0	\N	\N	\N	t	Butterflies - gold	Butterflies - gold	\N	\N
iitem_01KZ6CDN5VF00MTBPJG74FVJET	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Butterflies - silver	\N	\N	\N	\N	0	\N	\N	\N	t	Butterflies - silver	Butterflies - silver	\N	\N
iitem_01KZ6CDN5XE4779CCH3VTBP167	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Cherry	\N	\N	\N	\N	50	\N	\N	\N	t	Cherry	Cherry	\N	\N
iitem_01KZ6CDN5XA6JSG53XYSRRC1BX	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	cherry-earrings	\N	\N	\N	\N	60	\N	\N	\N	t	cherry-earrings	cherry-earrings	\N	\N
iitem_01KZ6CDN5YKWRCA0GFB9C2PXVH	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	DoubleDrama	\N	\N	\N	\N	40	\N	\N	\N	t	DoubleDrama	DoubleDrama	\N	\N
iitem_01KZ6CDN5YT1WY3TND8KBN2DRV	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	DG	\N	\N	\N	\N	40	\N	\N	\N	t	DG	DG	\N	\N
iitem_01KZ6CDN5Z7V2ATWR6NC71W4MG	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Ear candy	\N	\N	\N	\N	0	\N	\N	\N	t	Ear candy	Ear candy	\N	\N
iitem_01KZ6CDN5ZCRNP5FVKR02YQT92	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Teardrop	\N	\N	\N	\N	0	\N	\N	\N	t	Teardrop	Teardrop	\N	\N
iitem_01KZ6CDN5ZD7S577FVP4THMQXD	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Emerald Drops-Silver	\N	\N	\N	\N	600	\N	\N	\N	t	Emerald Drops-Silver	Emerald Drops-Silver	\N	\N
iitem_01KZ6CDN60QEB5711EFRWR71GP	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Emerald Drops-Gold	\N	\N	\N	\N	600	\N	\N	\N	t	Emerald Drops-Gold	Emerald Drops-Gold	\N	\N
iitem_01KZ6CDN60H6RHAEQ11AJYQ3QY	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	everyday	\N	\N	\N	\N	40	\N	\N	\N	t	everyday	everyday	\N	\N
iitem_01KZ6CDN60PPVVBQHCWP3MVY0P	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	fettuccine-silver	\N	\N	\N	\N	48	\N	\N	\N	t	fettuccine-silver	fettuccine-silver	\N	\N
iitem_01KZ6CDN61069HRCXTVNWAF4CB	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	fettuccine-gold	\N	\N	\N	\N	48	\N	\N	\N	t	fettuccine-gold	fettuccine-gold	\N	\N
iitem_01KZ6CDN615KKK9N3ZQZMKJJYM	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Forever Flower	\N	\N	\N	\N	48	\N	\N	\N	t	Forever Flower	Forever Flower	\N	\N
iitem_01KZ6CDN62FR8YMXB2FTENJF4Z	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Golden Dots	\N	\N	\N	\N	0	\N	\N	\N	t	Golden Dots	Golden Dots	\N	\N
iitem_01KZ6CDN6283RMHD7KNE9C89VA	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Golden Geometry	\N	\N	\N	\N	0	\N	\N	\N	t	Golden Geometry	Golden Geometry	\N	\N
iitem_01KZ6CDN63MFT9B4JTV616EG5F	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	Green Set	\N	\N	\N	\N	0	\N	\N	\N	t	Green Set	Green Set	\N	\N
iitem_01KZ6CDN63A9XT9E79MRB91SAM	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	fettuccine-1	\N	\N	\N	\N	48	\N	\N	\N	t	fettuccine-1	fettuccine-1	\N	\N
iitem_01KZ6CDN63AV8G39S081KFVX9D	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	fettuccine-2	\N	\N	\N	\N	48	\N	\N	\N	t	fettuccine-2	fettuccine-2	\N	\N
iitem_01KZ6CDN64TWKHS6WDEYAF4QTB	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	fettuccine-3	\N	\N	\N	\N	48	\N	\N	\N	t	fettuccine-3	fettuccine-3	\N	\N
iitem_01KZ6CDN649FDE6TE4N7A1Y074	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	fettuccine-4	\N	\N	\N	\N	48	\N	\N	\N	t	fettuccine-4	fettuccine-4	\N	\N
iitem_01KZ6CDN64RJ4V4T4TZMHAKTGQ	2026-08-04 12:36:50.524+00	2026-08-04 12:36:50.524+00	\N	IJAG - Rose Gold	\N	\N	\N	\N	0	\N	\N	\N	t	IJAG - Rose Gold	IJAG - Rose Gold	\N	\N
iitem_01KZ6CDN65V0K81YE2ZVMX6Y76	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	loop	\N	\N	\N	\N	100	\N	\N	\N	t	loop	loop	\N	\N
iitem_01KZ6CDN65HAJ30WJAFZZJ2CPE	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	MAS	\N	\N	\N	\N	0	\N	\N	\N	t	MAS	MAS	\N	\N
iitem_01KZ4ZYA48XDK3Y3WBS95Q9QRA	2026-08-03 23:39:30.316+00	2026-08-04 12:40:32.17+00	2026-08-04 12:40:32.165+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	Black	Black	\N	\N
iitem_01KYYM136QQ87RX03C0BFX0F44	2026-08-01 12:15:52.029+00	2026-08-04 17:20:30.362+00	2026-08-04 17:20:30.361+00	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01KYYM136QXP4G1YGP4NDRSZPX	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.377+00	2026-08-04 17:20:30.361+00	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01KYYM136W7ZVH1VR49X9XYFZC	2026-08-01 12:15:52.03+00	2026-08-04 17:20:33.275+00	2026-08-04 17:20:33.275+00	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01KYYM136W4RPAV4R8731DS4QE	2026-08-01 12:15:52.03+00	2026-08-04 17:20:33.288+00	2026-08-04 17:20:33.275+00	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01KYYM136WFA9S6NXX49NGEZNB	2026-08-01 12:15:52.03+00	2026-08-04 17:20:33.301+00	2026-08-04 17:20:33.275+00	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01KYYM136WQYJ7VK0SHB0VJQR2	2026-08-01 12:15:52.03+00	2026-08-04 17:20:33.314+00	2026-08-04 17:20:33.275+00	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01KYYM136V5QH1AFKVSNRWZKSC	2026-08-01 12:15:52.03+00	2026-08-04 17:20:36.556+00	2026-08-04 17:20:36.555+00	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01KYYM136VCPV7KGF8B85NBQD7	2026-08-01 12:15:52.03+00	2026-08-04 17:20:36.569+00	2026-08-04 17:20:36.555+00	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01KYYM136V6TRYDQD3FZQH0B4R	2026-08-01 12:15:52.03+00	2026-08-04 17:20:36.586+00	2026-08-04 17:20:36.555+00	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01KYYM136V4Q07XRGFCEWDF5CV	2026-08-01 12:15:52.03+00	2026-08-04 17:20:36.603+00	2026-08-04 17:20:36.555+00	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01KYYM136TKZ1BYPK65CV8R83E	2026-08-01 12:15:52.03+00	2026-08-04 17:20:40.313+00	2026-08-04 17:20:40.313+00	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01KYYM136TAZ1WR11AB0DX4T14	2026-08-01 12:15:52.03+00	2026-08-04 17:20:40.324+00	2026-08-04 17:20:40.313+00	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01KYYM136TYTEHYNSDGN2BADQ5	2026-08-01 12:15:52.03+00	2026-08-04 17:20:40.337+00	2026-08-04 17:20:40.313+00	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01KYYM136V0D05XYGVHBFTKNHN	2026-08-01 12:15:52.03+00	2026-08-04 17:20:40.35+00	2026-08-04 17:20:40.313+00	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01KZ6CDN5PJK4RKC3ZZF3S7Y1H	2026-08-04 12:36:50.522+00	2026-08-04 22:55:43.975+00	2026-08-04 22:55:43.975+00	BB - 1	\N	\N	\N	\N	0	\N	\N	\N	t	BB - 1	BB - 1	\N	\N
iitem_01KZ6CDN5PE1WTZNK2PX9WSCCF	2026-08-04 12:36:50.523+00	2026-08-04 22:55:48.696+00	2026-08-04 22:55:48.695+00	BB - 2	\N	\N	\N	\N	0	\N	\N	\N	t	BB - 2	BB - 2	\N	\N
iitem_01KZ6CDN5QSZFHN38P16VW57KH	2026-08-04 12:36:50.523+00	2026-08-04 22:55:53.119+00	2026-08-04 22:55:53.118+00	BB - 3	\N	\N	\N	\N	0	\N	\N	\N	t	BB - 3	BB - 3	\N	\N
iitem_01KZ6CDN5QVH9BQDMJA0361JH2	2026-08-04 12:36:50.523+00	2026-08-04 22:55:56.911+00	2026-08-04 22:55:56.911+00	BB - 4	\N	\N	\N	\N	0	\N	\N	\N	t	BB - 4	BB - 4	\N	\N
iitem_01KZ6CDN5VCQD47QDYTFCMDW8A	2026-08-04 12:36:50.524+00	2026-08-05 12:16:54.689+00	2026-08-05 12:16:54.687+00	Tennis - green	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis - green	Tennis - green	\N	\N
iitem_01KZ6CDN5VXHC2R9PC6YY5RDYD	2026-08-04 12:36:50.524+00	2026-08-05 12:16:59.834+00	2026-08-05 12:16:59.834+00	Tennis - black	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis - black	Tennis - black	\N	\N
iitem_01KZ6CDN5WT51ZVJFZBG58RC97	2026-08-04 12:36:50.524+00	2026-08-05 12:17:04.267+00	2026-08-05 12:17:04.266+00	Tennis - white	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis - white	Tennis - white	\N	\N
iitem_01KZ6CDN5WRTT34N4XYM5FR0RA	2026-08-04 12:36:50.524+00	2026-08-05 12:17:08.745+00	2026-08-05 12:17:08.742+00	Tennis - red	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis - red	Tennis - red	\N	\N
iitem_01KZ8Y2P89AS3HXGKR1YSQYVE9	2026-08-05 12:23:54.379+00	2026-08-05 12:23:54.379+00	\N	Tennis-white	\N	\N	\N	\N	\N	\N	\N	\N	t	White	White	\N	\N
iitem_01KZ6CDN652RDPFRG4ATTY1XKF	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Mermaids Necklace - Forever Flower	\N	\N	\N	\N	48	\N	\N	\N	t	Mermaids Necklace - Forever Flower	Mermaids Necklace - Forever Flower	\N	\N
iitem_01KZ6CDN66N70BQGFM84VV4E07	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Mirchi	\N	\N	\N	\N	40	\N	\N	\N	t	Mirchi	Mirchi	\N	\N
iitem_01KZ6CDN66HPZGE07GAVA3VDDN	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	My Heart	\N	\N	\N	\N	0	\N	\N	\N	t	My Heart	My Heart	\N	\N
iitem_01KZ6CDN67KPHWXS9TETP0493J	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Ocean Drop	\N	\N	\N	\N	48	\N	\N	\N	t	Ocean Drop	Ocean Drop	\N	\N
iitem_01KZ6CDN67K3YE2RXQ3W5EVTWV	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	OSC	\N	\N	\N	\N	0	\N	\N	\N	t	OSC	OSC	\N	\N
iitem_01KZ6CDN678N5NH3454BPXXR4J	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Opposites Attract-1	\N	\N	\N	\N	0	\N	\N	\N	t	Opposites Attract-1	Opposites Attract-1	\N	\N
iitem_01KZ6CDN68X63NB96MEDWMX232	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Opposites Attract-1-back-ring-6	\N	\N	\N	\N	0	\N	\N	\N	t	Opposites Attract-1-back-ring-6	Opposites Attract-1-back-ring-6	\N	\N
iitem_01KZ6CDN686DQ6XV5DCV7D6G6K	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Pearl Clasp	\N	\N	\N	\N	400	\N	\N	\N	t	Pearl Clasp	Pearl Clasp	\N	\N
iitem_01KZ6CDN690GYKMBK4XD9VXR3K	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Pearl Dots	\N	\N	\N	\N	0	\N	\N	\N	t	Pearl Dots	Pearl Dots	\N	\N
iitem_01KZ6CDN69NZEGMA6SZKTY5QA7	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	Pearly	\N	\N	\N	\N	0	\N	\N	\N	t	Pearly	Pearly	\N	\N
iitem_01KZ6CDN69VCX4A47ZW81M9FT8	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	ATME - Rose Gold	\N	\N	\N	\N	0	\N	\N	\N	t	ATME - Rose Gold	ATME - Rose Gold	\N	\N
iitem_01KZ6CDN6AXE8PAD3D0BF2RDQ9	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	ATME - Gold	\N	\N	\N	\N	0	\N	\N	\N	t	ATME - Gold	ATME - Gold	\N	\N
iitem_01KZ6CDN6A3JSQ7S5Y19D8KA9M	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	ATMB - Rose Gold	\N	\N	\N	\N	300	\N	\N	\N	t	ATMB - Rose Gold	ATMB - Rose Gold	\N	\N
iitem_01KZ6CDN6A4SQHE6E4X8ASSPK7	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	ATMB - Gold	\N	\N	\N	\N	300	\N	\N	\N	t	ATMB - Gold	ATMB - Gold	\N	\N
iitem_01KZ6CDN6BEY5VF0NE5NMVVQJN	2026-08-04 12:36:50.525+00	2026-08-04 12:36:50.525+00	\N	QR	\N	\N	\N	\N	0	\N	\N	\N	t	QR	QR	\N	\N
iitem_01KZ6CDN6CP3466X3XKBW3CF9T	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	S Ring	\N	\N	\N	\N	0	\N	\N	\N	t	S Ring	S Ring	\N	\N
iitem_01KZ6CDN6CC0CMJWAP87Y7NM7P	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	sakura	\N	\N	\N	\N	100	\N	\N	\N	t	sakura	sakura	\N	\N
iitem_01KZ6CDN6CHSTK44VXE0QDS9TB	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	starfish earrings	\N	\N	\N	\N	0	\N	\N	\N	t	starfish earrings	starfish earrings	\N	\N
iitem_01KZ6CDN6DBGCSWVG6D4E0QQV2	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	shapeshifter	\N	\N	\N	\N	60	\N	\N	\N	t	shapeshifter	shapeshifter	\N	\N
iitem_01KZ6CDN6E30KYG04SGS2AY5XR	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Starry Love-1	\N	\N	\N	\N	40	\N	\N	\N	t	Starry Love-1	Starry Love-1	\N	\N
iitem_01KZ6CDN6E5GH4KVSHPJ1F4R5Q	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Starry Love-2	\N	\N	\N	\N	40	\N	\N	\N	t	Starry Love-2	Starry Love-2	\N	\N
iitem_01KZ6CDN6FT6SCFEJ0J81G979P	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Starry Love-3	\N	\N	\N	\N	40	\N	\N	\N	t	Starry Love-3	Starry Love-3	\N	\N
iitem_01KZ6CDN6G1E5TRAZ2FZEX0BDJ	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Swirly	\N	\N	\N	\N	0	\N	\N	\N	t	Swirly	Swirly	\N	\N
iitem_01KZ6CDN6GX8HJS32MAN9WW0K3	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Tennis ring - red	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis ring - red	Tennis ring - red	\N	\N
iitem_01KZ6CDN6H2GJS2ZDGAW7Y7F4N	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Tennis ring	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis ring	Tennis ring	\N	\N
iitem_01KZ6CDN6HWXJ6A69W1GM91WTH	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Tennis ring - black	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis ring - black	Tennis ring - black	\N	\N
iitem_01KZ6CDN6JXAS1V602ZGW42RH3	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Tennis ring - green	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis ring - green	Tennis ring - green	\N	\N
iitem_01KZ6CDN6KGJSXZGAB0PXVZ4C3	2026-08-04 12:36:50.526+00	2026-08-04 12:36:50.526+00	\N	Tennis ring - white	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis ring - white	Tennis ring - white	\N	\N
iitem_01KZ6CDN6KTA6906X7TCHGS98P	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Tennis ring - purple	\N	\N	\N	\N	0	\N	\N	\N	t	Tennis ring - purple	Tennis ring - purple	\N	\N
iitem_01KZ6CDN6K8TX8AHJHYMJS0CPV	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Thunderstruck	\N	\N	\N	\N	0	\N	\N	\N	t	Thunderstruck	Thunderstruck	\N	\N
iitem_01KZ6CDN6M5MPETGA373YC0MRX	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Vechain-green-small	\N	\N	\N	\N	60	\N	\N	\N	t	Vechain-green-small	Vechain-green-small	\N	\N
iitem_01KZ6CDN6N8WK2607W74V9SY3M	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Vechain-green-large	\N	\N	\N	\N	10	\N	\N	\N	t	Vechain-green-large	Vechain-green-large	\N	\N
iitem_01KZ6CDN6NBQQ9JVQX37G6YWMP	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Vechain-white-small	\N	\N	\N	\N	60	\N	\N	\N	t	Vechain-white-small	Vechain-white-small	\N	\N
iitem_01KZ6CDN6N341JCXTY8Y5DN5AA	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Vechain-white-large	\N	\N	\N	\N	10	\N	\N	\N	t	Vechain-white-large	Vechain-white-large	\N	\N
iitem_01KZ6CDN6P88M5M2TFPS8KBXN3	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Vechain-black-small	\N	\N	\N	\N	60	\N	\N	\N	t	Vechain-black-small	Vechain-black-small	\N	\N
iitem_01KZ6CDN6QR9X8D7Q48HEKPMYT	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	Vechain-black-large	\N	\N	\N	\N	10	\N	\N	\N	t	Vechain-black-large	Vechain-black-large	\N	\N
iitem_01KZ6CDN6QBT9TB5WSPYA8BBYB	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	void	\N	\N	\N	\N	60	\N	\N	\N	t	void	void	\N	\N
iitem_01KZ6CDN6QV893HRZQNNAMEH3V	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	White Set	\N	\N	\N	\N	0	\N	\N	\N	t	White Set	White Set	\N	\N
iitem_01KZ6CDN6RDQZM2H5KGCFW91G2	2026-08-04 12:36:50.527+00	2026-08-04 12:36:50.527+00	\N	worly	\N	\N	\N	\N	40	\N	\N	\N	t	worly	worly	\N	\N
iitem_01KZ4ZYA4AC9CT7BGHE6NKK7S5	2026-08-03 23:39:30.317+00	2026-08-04 12:40:32.21+00	2026-08-04 12:40:32.165+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	White	White	\N	\N
iitem_01KZ6WJVMFGFYQ68690CJ992QM	2026-08-04 17:19:18.16+00	2026-08-04 17:19:18.16+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	Default variant	Default variant	\N	\N
iitem_01KYYM136RTRKXGXNV5EV0AE7M	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.397+00	2026-08-04 17:20:30.361+00	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01KYYM136RN5D71W3Q8NBVHMWT	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.409+00	2026-08-04 17:20:30.361+00	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01KYYM136R96R9Z34605ZDCJ46	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.422+00	2026-08-04 17:20:30.361+00	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01KYYM136SQNDX3D363SXAMHW4	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.434+00	2026-08-04 17:20:30.361+00	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01KYYM136STEN57Y417VF8VH3V	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.445+00	2026-08-04 17:20:30.361+00	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01KYYM136SBAV52Q6FQWZZ9GEZ	2026-08-01 12:15:52.03+00	2026-08-04 17:20:30.458+00	2026-08-04 17:20:30.361+00	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
iitem_01KZ7FWZB3NETWQZJ5DRQCC0XB	2026-08-04 22:56:52.579+00	2026-08-04 22:56:52.579+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-G-1	BB-G-1	\N	\N
iitem_01KZ7G00AYXZY3A9SFWKJXYGVE	2026-08-04 22:58:31.903+00	2026-08-04 22:58:31.903+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-G-2	BB-G-2	\N	\N
iitem_01KZ7G0ZMP840KG6CMMP2JZQX1	2026-08-04 22:59:03.958+00	2026-08-04 22:59:03.958+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-G-3	BB-G-3	\N	\N
iitem_01KZ7G1RGKHQGRWJ4ZEYXZTD13	2026-08-04 22:59:29.428+00	2026-08-04 22:59:29.428+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-G-4	BB-G-4	\N	\N
iitem_01KZ7G2M1PDN3MGXQWY609SCDK	2026-08-04 22:59:57.622+00	2026-08-04 22:59:57.622+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-S-1	BB-S-1	\N	\N
iitem_01KZ7G3DVNR1D6E8AY4YEM147T	2026-08-04 23:00:24.053+00	2026-08-04 23:00:24.053+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-S-2	BB-S-2	\N	\N
iitem_01KZ7G462FDM5XSQQ94N5314NG	2026-08-04 23:00:48.847+00	2026-08-04 23:00:48.847+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-S-3	BB-S-3	\N	\N
iitem_01KZ7G55KCH4M55FDZA76H7AWD	2026-08-04 23:01:21.132+00	2026-08-04 23:01:21.132+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	BB-S-4	BB-S-4	\N	\N
iitem_01KZ8XR8G4J1TY7WSNFV5JYVM0	2026-08-05 12:18:12.613+00	2026-08-05 12:18:12.613+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	Tennis-green	Tennis-green	\N	\N
iitem_01KZ8XZHFZANFHV66HRCANNA2H	2026-08-05 12:22:11.202+00	2026-08-05 12:22:11.202+00	\N	Tennis-blue	\N	\N	\N	\N	\N	\N	\N	\N	t	Blue	Blue	\N	\N
iitem_01KZ8Y13Z8RZEDQ3DPDTNB0J2H	2026-08-05 12:23:02.889+00	2026-08-05 12:23:02.889+00	\N	Tennis-black	\N	\N	\N	\N	\N	\N	\N	\N	t	Black	Black	\N	\N
iitem_01KZ8Y1YPRMR5588756CNRZY2A	2026-08-05 12:23:30.266+00	2026-08-05 12:23:30.266+00	\N	Tennis-red	\N	\N	\N	\N	\N	\N	\N	\N	t	Red	Red	\N	\N
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01KYYM13KAA28ET31NW5180NMR	2026-08-01 12:15:52.441+00	2026-08-04 17:20:30.377+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136QQ87RX03C0BFX0F44	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KB80GKYCCP1TDHQK2X	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.396+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136QXP4G1YGP4NDRSZPX	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KDQZ3R347PF5VQN9NM	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.409+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136RTRKXGXNV5EV0AE7M	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KC2S09K4KJHB2JSD9M	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.422+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136RN5D71W3Q8NBVHMWT	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KBT8VPRH6DXSH5C2WZ	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.434+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136R96R9Z34605ZDCJ46	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KEWPTNMD2R6GFPXV4T	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.444+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136SQNDX3D363SXAMHW4	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KQ47YPHD0G7JZJEPJC	2026-08-01 12:15:52.444+00	2026-08-04 17:20:33.287+00	2026-08-04 17:20:33.275+00	iitem_01KYYM136W7ZVH1VR49X9XYFZC	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KP9HD8V1WF3XX5X9FR	2026-08-01 12:15:52.444+00	2026-08-04 17:20:33.301+00	2026-08-04 17:20:33.275+00	iitem_01KYYM136W4RPAV4R8731DS4QE	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KQE3J5X96YH5RBTVMD	2026-08-01 12:15:52.444+00	2026-08-04 17:20:33.314+00	2026-08-04 17:20:33.275+00	iitem_01KYYM136WFA9S6NXX49NGEZNB	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KRRZPDYAXX76D5RQQ6	2026-08-01 12:15:52.444+00	2026-08-04 17:20:33.327+00	2026-08-04 17:20:33.275+00	iitem_01KYYM136WQYJ7VK0SHB0VJQR2	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KNFJVJNW309BGF8H6E	2026-08-01 12:15:52.444+00	2026-08-04 17:20:36.568+00	2026-08-04 17:20:36.555+00	iitem_01KYYM136V5QH1AFKVSNRWZKSC	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KPTAEGKWM136Q6AVFH	2026-08-01 12:15:52.444+00	2026-08-04 17:20:36.586+00	2026-08-04 17:20:36.555+00	iitem_01KYYM136VCPV7KGF8B85NBQD7	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KNXDMKKJX25V1GNWG9	2026-08-01 12:15:52.444+00	2026-08-04 17:20:36.602+00	2026-08-04 17:20:36.555+00	iitem_01KYYM136V6TRYDQD3FZQH0B4R	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KMV0DK380P4ZCAMB4F	2026-08-01 12:15:52.444+00	2026-08-04 17:20:36.62+00	2026-08-04 17:20:36.555+00	iitem_01KYYM136V4Q07XRGFCEWDF5CV	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KHKZT8YKBYKDSY82SQ	2026-08-01 12:15:52.443+00	2026-08-04 17:20:40.323+00	2026-08-04 17:20:40.313+00	iitem_01KYYM136TKZ1BYPK65CV8R83E	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KF0851E6R8J0Q8079S	2026-08-01 12:15:52.443+00	2026-08-04 17:20:40.336+00	2026-08-04 17:20:40.313+00	iitem_01KYYM136TAZ1WR11AB0DX4T14	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KJVY40W58XYJ3D1C45	2026-08-01 12:15:52.444+00	2026-08-04 17:20:40.35+00	2026-08-04 17:20:40.313+00	iitem_01KYYM136TYTEHYNSDGN2BADQ5	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KKJJG1Q4JPKEZSGPTH	2026-08-01 12:15:52.444+00	2026-08-04 17:20:40.362+00	2026-08-04 17:20:40.313+00	iitem_01KYYM136V0D05XYGVHBFTKNHN	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KE11P35H5HKGBA3KTK	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.458+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136STEN57Y417VF8VH3V	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KYYM13KDVZJ5H0PX1BGJJZN7	2026-08-01 12:15:52.443+00	2026-08-04 17:20:30.472+00	2026-08-04 17:20:30.361+00	iitem_01KYYM136SBAV52Q6FQWZZ9GEZ	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KZ7EFJ8Q80F2B60XCQJETC79	2026-08-04 22:32:04.632+00	2026-08-04 22:32:11.933+00	2026-08-04 22:32:11.931+00	iitem_01KZ6CDN5N7VTJQZGQT8HN5GCJ	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	0	0	0	\N	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01KZ7EHC6KRGTXTYYREHV3R4CN	2026-08-04 22:33:03.956+00	2026-08-04 22:33:12.418+00	2026-08-04 22:33:12.418+00	iitem_01KZ6CDN5NZ4RP94G6VXART3VD	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	0	0	0	\N	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: invite_rbac_role; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.invite_rbac_role (invite_id, rbac_role_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: layout_configuration; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.layout_configuration (id, zone, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2026-08-01 12:11:39.210476
2	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2026-08-01 12:11:39.365674
3	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2026-08-01 12:11:39.433529
4	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2026-08-01 12:11:39.516043
5	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2026-08-01 12:11:39.606809
6	invite_rbac_role	{"toModel": "rbac_role", "toModule": "rbac", "fromModel": "invite", "fromModule": "user"}	2026-08-01 12:11:39.743175
7	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2026-08-01 12:11:39.818439
8	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2026-08-01 12:11:39.962255
9	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2026-08-01 12:11:40.025329
10	order_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2026-08-01 12:11:40.076633
11	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2026-08-01 12:11:40.138313
12	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2026-08-01 12:11:40.280179
13	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2026-08-01 12:11:40.32979
14	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2026-08-01 12:11:40.374191
15	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2026-08-01 12:11:40.484452
16	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2026-08-01 12:11:40.568969
17	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2026-08-01 12:11:40.659721
18	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2026-08-01 12:11:40.732968
19	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2026-08-01 12:11:40.866167
20	user_rbac_role	{"toModel": "rbac_role", "toModule": "rbac", "fromModel": "user", "fromModule": "user"}	2026-08-01 12:11:40.932135
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	manual_manual	locfp_01KYYM11JNM1DYMBCA8FZZ9CB5	2026-08-01 12:15:50.358189+00	2026-08-01 12:15:50.358189+00	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	fuset_01KYYM11N9M85PX2PD9JN4DCFX	locfs_01KYYM11QNJ0RXXQ4X3W430GAH	2026-08-01 12:15:50.523885+00	2026-08-01 12:15:50.523885+00	\N
sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	fuset_01KZ7ERWTD8QAWWT7WJTZHJJCK	locfs_01KZ7ERWV8NHNF87QF15SFE134	2026-08-04 22:37:10.323879+00	2026-08-04 22:37:10.323879+00	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2026-08-01 12:10:57.824242+00
2	Migration20241210073813	2026-08-01 12:10:57.824242+00
3	Migration20250106142624	2026-08-01 12:10:57.824242+00
4	Migration20250120110820	2026-08-01 12:10:57.824242+00
5	Migration20240307132720	2026-08-01 12:10:58.596171+00
6	Migration20240719123015	2026-08-01 12:10:58.596171+00
7	Migration20241213063611	2026-08-01 12:10:58.596171+00
8	Migration20251010131115	2026-08-01 12:10:58.596171+00
9	InitialSetup20240401153642	2026-08-01 12:10:59.715056+00
10	Migration20240601111544	2026-08-01 12:10:59.715056+00
11	Migration202408271511	2026-08-01 12:10:59.715056+00
12	Migration20241122120331	2026-08-01 12:10:59.715056+00
13	Migration20241125090957	2026-08-01 12:10:59.715056+00
14	Migration20250411073236	2026-08-01 12:10:59.715056+00
15	Migration20250516081326	2026-08-01 12:10:59.715056+00
16	Migration20250910154539	2026-08-01 12:10:59.715056+00
17	Migration20250911092221	2026-08-01 12:10:59.715056+00
18	Migration20250929204438	2026-08-01 12:10:59.715056+00
19	Migration20251008132218	2026-08-01 12:10:59.715056+00
20	Migration20251011090511	2026-08-01 12:10:59.715056+00
21	Migration20251022153442	2026-08-01 12:10:59.715056+00
22	Migration20251029150809	2026-08-01 12:10:59.715056+00
23	Migration20251110180907	2026-08-01 12:10:59.715056+00
24	Migration20251113183352	2026-08-01 12:10:59.715056+00
25	Migration20260224120000	2026-08-01 12:10:59.715056+00
26	Migration20260301002050	2026-08-01 12:10:59.715056+00
27	Migration20260306120000	2026-08-01 12:10:59.715056+00
28	Migration20260623180000	2026-08-01 12:10:59.715056+00
29	Migration20230929122253	2026-08-01 12:11:04.020143+00
30	Migration20240322094407	2026-08-01 12:11:04.020143+00
31	Migration20240322113359	2026-08-01 12:11:04.020143+00
32	Migration20240322120125	2026-08-01 12:11:04.020143+00
33	Migration20240626133555	2026-08-01 12:11:04.020143+00
34	Migration20240704094505	2026-08-01 12:11:04.020143+00
35	Migration20241127114534	2026-08-01 12:11:04.020143+00
36	Migration20241127223829	2026-08-01 12:11:04.020143+00
37	Migration20241128055359	2026-08-01 12:11:04.020143+00
38	Migration20241212190401	2026-08-01 12:11:04.020143+00
39	Migration20250408145122	2026-08-01 12:11:04.020143+00
40	Migration20250409122219	2026-08-01 12:11:04.020143+00
41	Migration20251009110625	2026-08-01 12:11:04.020143+00
42	Migration20251112192723	2026-08-01 12:11:04.020143+00
43	Migration20260429163502	2026-08-01 12:11:04.020143+00
44	Migration20240227120221	2026-08-01 12:11:07.234352+00
45	Migration20240617102917	2026-08-01 12:11:07.234352+00
46	Migration20240624153824	2026-08-01 12:11:07.234352+00
47	Migration20241211061114	2026-08-01 12:11:07.234352+00
48	Migration20250113094144	2026-08-01 12:11:07.234352+00
49	Migration20250120110700	2026-08-01 12:11:07.234352+00
50	Migration20250226130616	2026-08-01 12:11:07.234352+00
51	Migration20250508081510	2026-08-01 12:11:07.234352+00
52	Migration20250828075407	2026-08-01 12:11:07.234352+00
53	Migration20250909083125	2026-08-01 12:11:07.234352+00
54	Migration20250916120552	2026-08-01 12:11:07.234352+00
55	Migration20250917143818	2026-08-01 12:11:07.234352+00
56	Migration20250919122137	2026-08-01 12:11:07.234352+00
57	Migration20251006000000	2026-08-01 12:11:07.234352+00
58	Migration20251015113934	2026-08-01 12:11:07.234352+00
59	Migration20251107050148	2026-08-01 12:11:07.234352+00
60	Migration20240124154000	2026-08-01 12:11:10.366045+00
61	Migration20240524123112	2026-08-01 12:11:10.366045+00
62	Migration20240602110946	2026-08-01 12:11:10.366045+00
63	Migration20241211074630	2026-08-01 12:11:10.366045+00
64	Migration20251010130829	2026-08-01 12:11:10.366045+00
65	Migration20240115152146	2026-08-01 12:11:11.439917+00
66	Migration20240222170223	2026-08-01 12:11:11.899598+00
67	Migration20240831125857	2026-08-01 12:11:11.899598+00
68	Migration20241106085918	2026-08-01 12:11:11.899598+00
69	Migration20241205095237	2026-08-01 12:11:11.899598+00
70	Migration20241216183049	2026-08-01 12:11:11.899598+00
71	Migration20241218091938	2026-08-01 12:11:11.899598+00
72	Migration20250120115059	2026-08-01 12:11:11.899598+00
73	Migration20250212131240	2026-08-01 12:11:11.899598+00
74	Migration20250326151602	2026-08-01 12:11:11.899598+00
75	Migration20250508081553	2026-08-01 12:11:11.899598+00
76	Migration20251017153909	2026-08-01 12:11:11.899598+00
77	Migration20251208130704	2026-08-01 12:11:11.899598+00
78	Migration20260626000000	2026-08-01 12:11:11.899598+00
79	Migration20240205173216	2026-08-01 12:11:13.921852+00
80	Migration20240624200006	2026-08-01 12:11:13.921852+00
81	Migration20250120110744	2026-08-01 12:11:13.921852+00
82	InitialSetup20240221144943	2026-08-01 12:11:14.510878+00
83	Migration20240604080145	2026-08-01 12:11:14.510878+00
84	Migration20241205122700	2026-08-01 12:11:14.510878+00
85	Migration20251015123842	2026-08-01 12:11:14.510878+00
86	InitialSetup20240227075933	2026-08-01 12:11:15.200497+00
87	Migration20240621145944	2026-08-01 12:11:15.200497+00
88	Migration20241206083313	2026-08-01 12:11:15.200497+00
89	Migration20251202184737	2026-08-01 12:11:15.200497+00
90	Migration20251212161429	2026-08-01 12:11:15.200497+00
91	Migration20240227090331	2026-08-01 12:11:16.149258+00
92	Migration20240710135844	2026-08-01 12:11:16.149258+00
93	Migration20240924114005	2026-08-01 12:11:16.149258+00
94	Migration20241212052837	2026-08-01 12:11:16.149258+00
95	InitialSetup20240228133303	2026-08-01 12:11:17.113382+00
96	Migration20240624082354	2026-08-01 12:11:17.113382+00
97	Migration20240225134525	2026-08-01 12:11:17.575944+00
98	Migration20240806072619	2026-08-01 12:11:17.575944+00
99	Migration20241211151053	2026-08-01 12:11:17.575944+00
100	Migration20250115160517	2026-08-01 12:11:17.575944+00
101	Migration20250120110552	2026-08-01 12:11:17.575944+00
102	Migration20250123122334	2026-08-01 12:11:17.575944+00
103	Migration20250206105639	2026-08-01 12:11:17.575944+00
104	Migration20250207132723	2026-08-01 12:11:17.575944+00
105	Migration20250625084134	2026-08-01 12:11:17.575944+00
106	Migration20250924135437	2026-08-01 12:11:17.575944+00
107	Migration20250929124701	2026-08-01 12:11:17.575944+00
108	Migration20260411223700	2026-08-01 12:11:17.575944+00
109	Migration20240219102530	2026-08-01 12:11:19.759624+00
110	Migration20240604100512	2026-08-01 12:11:19.759624+00
111	Migration20240715102100	2026-08-01 12:11:19.759624+00
112	Migration20240715174100	2026-08-01 12:11:19.759624+00
113	Migration20240716081800	2026-08-01 12:11:19.759624+00
114	Migration20240801085921	2026-08-01 12:11:19.759624+00
115	Migration20240821164505	2026-08-01 12:11:19.759624+00
116	Migration20240821170920	2026-08-01 12:11:19.759624+00
117	Migration20240827133639	2026-08-01 12:11:19.759624+00
118	Migration20240902195921	2026-08-01 12:11:19.759624+00
119	Migration20240913092514	2026-08-01 12:11:19.759624+00
120	Migration20240930122627	2026-08-01 12:11:19.759624+00
121	Migration20241014142943	2026-08-01 12:11:19.759624+00
122	Migration20241106085223	2026-08-01 12:11:19.759624+00
123	Migration20241129124827	2026-08-01 12:11:19.759624+00
124	Migration20241217162224	2026-08-01 12:11:19.759624+00
125	Migration20250326151554	2026-08-01 12:11:19.759624+00
126	Migration20250522181137	2026-08-01 12:11:19.759624+00
127	Migration20250702095353	2026-08-01 12:11:19.759624+00
128	Migration20250704120229	2026-08-01 12:11:19.759624+00
129	Migration20250910130000	2026-08-01 12:11:19.759624+00
130	Migration20251016160403	2026-08-01 12:11:19.759624+00
131	Migration20251016182939	2026-08-01 12:11:19.759624+00
132	Migration20251017155709	2026-08-01 12:11:19.759624+00
133	Migration20251114100559	2026-08-01 12:11:19.759624+00
134	Migration20251125164002	2026-08-01 12:11:19.759624+00
135	Migration20251210112909	2026-08-01 12:11:19.759624+00
136	Migration20251210112924	2026-08-01 12:11:19.759624+00
137	Migration20251225120947	2026-08-01 12:11:19.759624+00
138	Migration20260106185528	2026-08-01 12:11:19.759624+00
139	Migration20260625000000	2026-08-01 12:11:19.759624+00
140	Migration20250717162007	2026-08-01 12:11:26.07271+00
141	Migration20260127081758	2026-08-01 12:11:26.07271+00
142	Migration20260615151246	2026-08-01 12:11:26.07271+00
143	Migration20240205025928	2026-08-01 12:11:27.050753+00
144	Migration20240529080336	2026-08-01 12:11:27.050753+00
145	Migration20241202100304	2026-08-01 12:11:27.050753+00
146	Migration20260514083900	2026-08-01 12:11:27.050753+00
147	Migration20260525090000	2026-08-01 12:11:27.050753+00
148	Migration20260604120000	2026-08-01 12:11:27.050753+00
149	Migration20260616075929	2026-08-01 12:11:27.050753+00
150	Migration20240214033943	2026-08-01 12:11:29.173914+00
151	Migration20240703095850	2026-08-01 12:11:29.173914+00
152	Migration20241202103352	2026-08-01 12:11:29.173914+00
153	Migration20240311145700_InitialSetupMigration	2026-08-01 12:11:30.073261+00
154	Migration20240821170957	2026-08-01 12:11:30.073261+00
155	Migration20240917161003	2026-08-01 12:11:30.073261+00
156	Migration20241217110416	2026-08-01 12:11:30.073261+00
157	Migration20250113122235	2026-08-01 12:11:30.073261+00
158	Migration20250120115002	2026-08-01 12:11:30.073261+00
159	Migration20250822130931	2026-08-01 12:11:30.073261+00
160	Migration20250825132614	2026-08-01 12:11:30.073261+00
161	Migration20251114133146	2026-08-01 12:11:30.073261+00
162	Migration20240509083918_InitialSetupMigration	2026-08-01 12:11:32.201054+00
163	Migration20240628075401	2026-08-01 12:11:32.201054+00
164	Migration20240830094712	2026-08-01 12:11:32.201054+00
165	Migration20250120110514	2026-08-01 12:11:32.201054+00
166	Migration20251028172715	2026-08-01 12:11:32.201054+00
167	Migration20251121123942	2026-08-01 12:11:32.201054+00
168	Migration20251121150408	2026-08-01 12:11:32.201054+00
169	Migration20231228143900	2026-08-01 12:11:33.935207+00
170	Migration20241206101446	2026-08-01 12:11:33.935207+00
171	Migration20250128174331	2026-08-01 12:11:33.935207+00
172	Migration20250505092459	2026-08-01 12:11:33.935207+00
173	Migration20250819104213	2026-08-01 12:11:33.935207+00
174	Migration20250819110924	2026-08-01 12:11:33.935207+00
175	Migration20250908080305	2026-08-01 12:11:33.935207+00
176	Migration20260411221609	2026-08-05 19:43:37.259409+00
177	Migration20260713014233	2026-08-05 19:43:37.259409+00
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status, "from", provider_data) FROM stdin;
noti_01KZ4ZYXYQ39T2NND50XFPX38C		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1785800390062-1785800390060-product-exports.csv", "filename": "1785800390060-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-03 23:39:50.62+00	2026-08-03 23:39:50.67+00	\N	success	\N	\N
noti_01KZ505Z9FYZ8A2AG36VSFG34C		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1785800620587-1785800620586-product-exports.csv", "filename": "1785800620586-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-03 23:43:41.362+00	2026-08-03 23:43:41.443+00	\N	success	\N	\N
noti_01KZ50TC281276AW5C6JGMRRQF		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1785801289345-1785801289344-product-exports.csv", "filename": "1785801289344-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-03 23:54:49.802+00	2026-08-03 23:54:49.84+00	\N	success	\N	\N
noti_01KZ5174YN7Q58Z4ATK4SWHH0T		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1785801707983-1785801707982-product-exports.csv", "filename": "1785801707982-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 00:01:48.503+00	2026-08-04 00:01:48.577+00	\N	success	\N	\N
noti_01KZ663QCKN28RRMA39P570339		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 10:46:33.621+00	2026-08-04 10:46:33.675+00	\N	success	\N	\N
noti_01KZ6B0ACFDCGA3591ZKHXZSCR		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 12:12:04.881+00	2026-08-04 12:12:04.93+00	\N	success	\N	\N
noti_01KZ6BG0WM227H1DDN8PNNND9J		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 12:20:39.445+00	2026-08-04 12:20:39.475+00	\N	success	\N	\N
noti_01KZ6BYSFE610MYC4R0JAE8Z1W		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file medusa_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 12:28:43.375+00	2026-08-04 12:28:43.397+00	\N	success	\N	\N
noti_01KZ6CDPBJF4VW71WCY1ZNXYSB		feed	admin-ui	{"title": "Product import", "description": "Product import of file medusa_import.csv completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 12:36:51.701+00	2026-08-04 12:36:51.74+00	\N	success	\N	\N
noti_01KZ6DSCZ6F04RTM8T3VVAK2FQ		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1785848442961-1785848442961-product-exports.csv", "filename": "1785848442961-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2026-08-04 13:00:43.879+00	2026-08-04 13:00:43.898+00	\N	success	\N	\N
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2026-08-01 12:14:52.484+00	2026-08-01 12:14:52.484+00	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at, custom_display_id, locale) FROM stdin;
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id, carry_over_promotions) FROM stdin;
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at, version) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at, is_tax_inclusive, version) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at, metadata, data) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at, version) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at, metadata, data) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2026-08-01 12:14:52.465+00	2026-08-01 12:14:52.465+00	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity, raw_min_quantity, raw_max_quantity) FROM stdin;
price_01KYYM122ATEACE4D7H10TP08T	\N	pset_01KYYM122E03VWTGPJNZ3VCJR0	usd	{"value": "10", "precision": 20}	0	2026-08-01 12:15:50.87+00	2026-08-01 12:15:50.87+00	\N	\N	10	\N	\N	\N	\N
price_01KYYM122BMETMVFFQN0Q12GBD	\N	pset_01KYYM122E03VWTGPJNZ3VCJR0	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:50.871+00	2026-08-01 12:15:50.871+00	\N	\N	10	\N	\N	\N	\N
price_01KYYM122EQ0H0JYJ23CCVDHSR	\N	pset_01KYYM122E03VWTGPJNZ3VCJR0	eur	{"value": "10", "precision": 20}	1	2026-08-01 12:15:50.871+00	2026-08-01 12:15:50.871+00	\N	\N	10	\N	\N	\N	\N
price_01KYYM122FWC0AGVHJ5M3JH2EA	\N	pset_01KYYM122KDCQ6M2Q7G20B37NM	usd	{"value": "10", "precision": 20}	0	2026-08-01 12:15:50.872+00	2026-08-01 12:15:50.872+00	\N	\N	10	\N	\N	\N	\N
price_01KYYM122GXSKPWN795C287N76	\N	pset_01KYYM122KDCQ6M2Q7G20B37NM	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:50.872+00	2026-08-01 12:15:50.872+00	\N	\N	10	\N	\N	\N	\N
price_01KYYM122J760BASE5B93YP5MM	\N	pset_01KYYM122KDCQ6M2Q7G20B37NM	eur	{"value": "10", "precision": 20}	1	2026-08-01 12:15:50.872+00	2026-08-01 12:15:50.872+00	\N	\N	10	\N	\N	\N	\N
price_01KYYM13AHX42CPR8QDXMH0SF1	\N	pset_01KYYM13AJ4CHK4RCBRVA5JW7T	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.426+00	2026-08-04 17:20:33.416+00	\N	10	\N	\N	\N	\N
price_01KYYM13AJBJ7Z8HAPT7K9TMCG	\N	pset_01KYYM13AJ4CHK4RCBRVA5JW7T	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.426+00	2026-08-04 17:20:33.416+00	\N	15	\N	\N	\N	\N
price_01KYYM13AJDMVH5P7B6A7NTQP8	\N	pset_01KYYM13AK1M83SRFKDV0EZ92J	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.451+00	2026-08-04 17:20:33.416+00	\N	10	\N	\N	\N	\N
price_01KYYM13AKRD98FQKHJGRP1D96	\N	pset_01KYYM13AK1M83SRFKDV0EZ92J	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.451+00	2026-08-04 17:20:33.416+00	\N	15	\N	\N	\N	\N
price_01KYYM13AM7891STG47KBK7ZYY	\N	pset_01KYYM13ANWE45PGS6FTAFW891	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.477+00	2026-08-04 17:20:33.416+00	\N	10	\N	\N	\N	\N
price_01KYYM13AMH9TNYP5BC68FZHN8	\N	pset_01KYYM13ANWE45PGS6FTAFW891	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.477+00	2026-08-04 17:20:33.416+00	\N	15	\N	\N	\N	\N
price_01KYYM13ANBF4D756RPWZ4MQD1	\N	pset_01KYYM13AP1VJ8WS9JV8HW5V0Y	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.502+00	2026-08-04 17:20:33.416+00	\N	10	\N	\N	\N	\N
price_01KYYM13AD88RV0YW3975VWXZM	\N	pset_01KYYM13AEJ76N13RV163E3CYY	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.722+00	2026-08-04 17:20:36.711+00	\N	10	\N	\N	\N	\N
price_01KYYM13AE4GDMREVHT7VNTXVF	\N	pset_01KYYM13AEJ76N13RV163E3CYY	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.723+00	2026-08-04 17:20:36.711+00	\N	15	\N	\N	\N	\N
price_01KYYM13AE5M8G1BZVQR5PE8WZ	\N	pset_01KYYM13AFW7BYET0YK90NT4G5	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.751+00	2026-08-04 17:20:36.711+00	\N	10	\N	\N	\N	\N
price_01KYYM13AEEKKZRMNXNKDJYYBN	\N	pset_01KYYM13AFW7BYET0YK90NT4G5	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.751+00	2026-08-04 17:20:36.711+00	\N	15	\N	\N	\N	\N
price_01KYYM13AF4GK2Y6GDP7228KGJ	\N	pset_01KYYM13AGMZJPNVK2FTCTW0T7	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.783+00	2026-08-04 17:20:36.711+00	\N	10	\N	\N	\N	\N
price_01KYYM13AGMGEHJ73P8ZSE1JWQ	\N	pset_01KYYM13AGMZJPNVK2FTCTW0T7	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.783+00	2026-08-04 17:20:36.711+00	\N	15	\N	\N	\N	\N
price_01KYYM13AG7N5A5KBASW068PZ7	\N	pset_01KYYM13AHVA0F4G30PJQ3ZC8R	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.812+00	2026-08-04 17:20:36.711+00	\N	10	\N	\N	\N	\N
price_01KYYM13AG27TSM3J265WWKEG2	\N	pset_01KYYM13AHVA0F4G30PJQ3ZC8R	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:36.812+00	2026-08-04 17:20:36.711+00	\N	15	\N	\N	\N	\N
price_01KYYM13A9KRRPJ9XC665BP02S	\N	pset_01KYYM13AARN1HQA2JFEN5VQTP	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:40.445+00	2026-08-04 17:20:40.436+00	\N	10	\N	\N	\N	\N
price_01KYYM13AA17CBHACWQ861GP36	\N	pset_01KYYM13AARN1HQA2JFEN5VQTP	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:40.446+00	2026-08-04 17:20:40.436+00	\N	15	\N	\N	\N	\N
price_01KYYM13AA4BKQ1KTS6W9HM51M	\N	pset_01KYYM13ABACPTPSKXKAFH29K4	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:40.469+00	2026-08-04 17:20:40.436+00	\N	10	\N	\N	\N	\N
price_01KYYM13AAZC8KMJCG3E5PXVR5	\N	pset_01KYYM13ABACPTPSKXKAFH29K4	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:40.469+00	2026-08-04 17:20:40.436+00	\N	15	\N	\N	\N	\N
price_01KYYM13ABCTPGGFJD1T80GYQF	\N	pset_01KYYM13ACW862P4AFH0NRF18R	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:40.493+00	2026-08-04 17:20:40.436+00	\N	10	\N	\N	\N	\N
price_01KYYM13ABVK8FR85VGK990CS0	\N	pset_01KYYM13ACW862P4AFH0NRF18R	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:40.493+00	2026-08-04 17:20:40.436+00	\N	15	\N	\N	\N	\N
price_01KYYM13ACM3PM5B98ZXV4DA5S	\N	pset_01KYYM13ADYCWVZ4GXXSNX25KZ	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:40.52+00	2026-08-04 17:20:40.436+00	\N	10	\N	\N	\N	\N
price_01KYYM13AD15GK2SJG23GN6DA2	\N	pset_01KYYM13ADYCWVZ4GXXSNX25KZ	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:40.52+00	2026-08-04 17:20:40.436+00	\N	15	\N	\N	\N	\N
price_01KZ6CDNKJHBR9PGG8S0DHZPXB	\N	pset_01KZ6CDNKK5MNHWR8400KGPC3P	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNKKJG91Y6H2CVA0DAZJ	\N	pset_01KZ6CDNKMQ5W80136AV6AX19Z	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNKM28PSXV7WGJQQ26ZA	\N	pset_01KZ6CDNKN23R9BC98G8XBA1V0	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNKSEMPAAY0KTDTT65WA	\N	pset_01KZ6CDNKSWZR2TSBGZ3GPA0AH	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNKT8GYX1SH1C3EPBMAX	\N	pset_01KZ6CDNKTKK34WD04BP2R2Y0M	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNKVC2WVC2J3CDKK7H44	\N	pset_01KZ6CDNKV8Y9TZN1YNJ4G4CWB	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNKVQ98CB9HS9RYZ5KXS	\N	pset_01KZ6CDNKWXMVWDQXK7TW6C5PM	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNKXZNTMM6S7MY96H5YX	\N	pset_01KZ6CDNKX87AAHCP43EJEJQ6T	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNM15KYM8262VPSK8BFT	\N	pset_01KZ6CDNM2PYC1WFK74P8B0KE6	inr	{"value": "799", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	799	\N	\N	\N	\N
price_01KZ6CDNM2VBH6P2VX08P72776	\N	pset_01KZ6CDNM3SJ2DXE9YXY6FYRG0	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNM3N6Q1D3HHGVYEXWTE	\N	pset_01KZ6CDNM3ETYSERJ2JCP0ZYHR	inr	{"value": "799", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	799	\N	\N	\N	\N
price_01KZ6CDNM4GK60PRXWKGVA3NZ9	\N	pset_01KZ6CDNM4Q64A2M2XBE3W7Q5D	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNM5V4S1QVP3W5WV3DY5	\N	pset_01KZ6CDNM57VKQD39962B4YRAH	inr	{"value": "899", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	899	\N	\N	\N	\N
price_01KZ6CDNM58CAMDEJ52QN5Y6D8	\N	pset_01KZ6CDNM66W7NQSJHNH2ECZA2	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNM6YS5HCHDPF6MQ4BHD	\N	pset_01KZ6CDNM6F6P2BHKM1CG3NYT6	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNM710DFXSK2HZX7G9QM	\N	pset_01KZ6CDNM778PVGESD65Y2TFVJ	inr	{"value": "899", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.012+00	\N	\N	899	\N	\N	\N	\N
price_01KZ6CDNM879WSPXJ1M54VH2E4	\N	pset_01KZ6CDNM95KKRF23Z0AXJC54E	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 12:36:51.013+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNMAQ04RE52NN6TG722V	\N	pset_01KZ6CDNMATHEP453YDRFTSG9R	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNMBGRZG2259WCAN9518	\N	pset_01KZ6CDNMBWYSES2647Q638K89	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNMCHEEG1EK2ZZ4VJ41D	\N	pset_01KZ6CDNMCW0JPX8R3J5B4DC44	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNMDTGFWEBQJM6WK52Q9	\N	pset_01KZ6CDNMD8ZBSXCT3EQRH9PPS	inr	{"value": "299", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	299	\N	\N	\N	\N
price_01KZ6CDNMEY76YS33D3Z5CVJTT	\N	pset_01KZ6CDNMEQHDJSXM7TCXTZ5JR	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNMEMEXD6AQW791T41RP	\N	pset_01KZ6CDNMF3JK1EZMB28AVNS22	inr	{"value": "2499", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	2499	\N	\N	\N	\N
price_01KZ6CDNMFV4QC4MZMNG6YDSBX	\N	pset_01KZ6CDNMGCWGJVDGKPCJN8WHQ	inr	{"value": "799", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	799	\N	\N	\N	\N
price_01KZ6CDNMGC03ZQ4JHN4Q14PSF	\N	pset_01KZ6CDNMHAZPFCMFVFVK8ND2H	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNMH3Z6M3N91KYQBZ3BE	\N	pset_01KZ6CDNMHWX6ZCV8MN22GGYSR	inr	{"value": "1399", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	1399	\N	\N	\N	\N
price_01KZ6CDNMJRDA9YYTKKCV62Q70	\N	pset_01KZ6CDNMJBZ4NGMJZ1C3Z689M	inr	{"value": "99", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	99	\N	\N	\N	\N
price_01KZ6CDNMKG1BCS3CR98MN9HP8	\N	pset_01KZ6CDNMKJ4BK5T4M6ZR0BZ2Z	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	999	\N	\N	\N	\N
price_01KYYM13AN2B031G8MVAK6JJ2R	\N	pset_01KYYM13AP1VJ8WS9JV8HW5V0Y	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.153+00	2026-08-04 17:20:33.503+00	2026-08-04 17:20:33.416+00	\N	15	\N	\N	\N	\N
price_01KZ6CDNKNBBDCMP9MST3XNQRT	\N	pset_01KZ6CDNKNQK3R2RZ6Z0ZGE5CZ	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.011+00	2026-08-04 22:55:43.924+00	2026-08-04 22:55:43.907+00	\N	999	\N	\N	\N	\N
price_01KZ6CDNKPR11CWBY24HCR93XD	\N	pset_01KZ6CDNKP3M9VPP6T9BBP0NBW	inr	{"value": "1399", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 22:55:48.648+00	2026-08-04 22:55:48.637+00	\N	1399	\N	\N	\N	\N
price_01KZ6CDNKQ1ZWH8VHS6FP1436R	\N	pset_01KZ6CDNKQ01CRDP40M8VV0RH1	inr	{"value": "1999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 22:55:53.07+00	2026-08-04 22:55:53.06+00	\N	1999	\N	\N	\N	\N
price_01KZ6CDNKRK5G6TG8BD9CCX8E6	\N	pset_01KZ6CDNKR9JDVRZGY7N3X8EXB	inr	{"value": "2499", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-04 22:55:56.857+00	2026-08-04 22:55:56.836+00	\N	2499	\N	\N	\N	\N
price_01KZ6CDNKYHM5GV3ET5QNH0KJW	\N	pset_01KZ6CDNKYPWF5QVXBMZVZZPMV	inr	{"value": "1999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-05 12:16:54.522+00	2026-08-05 12:16:54.485+00	\N	1999	\N	\N	\N	\N
price_01KZ6CDNKZ7TT9XNR831M48DNS	\N	pset_01KZ6CDNKZ9G9XRVA00X38W1X1	inr	{"value": "1999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-05 12:16:59.712+00	2026-08-05 12:16:59.679+00	\N	1999	\N	\N	\N	\N
price_01KZ6CDNKZBHWFPAEYEEN0QCGG	\N	pset_01KZ6CDNM0BB8YGVCRQCJVVNG4	inr	{"value": "1999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-05 12:17:04.162+00	2026-08-05 12:17:04.132+00	\N	1999	\N	\N	\N	\N
price_01KZ6CDNM1A2D63FEZMNWRR9AW	\N	pset_01KZ6CDNM1HH2SXT0A72VEJ5P6	inr	{"value": "1999", "precision": 20}	0	2026-08-04 12:36:51.012+00	2026-08-05 12:17:08.598+00	2026-08-05 12:17:08.561+00	\N	1999	\N	\N	\N	\N
price_01KZ6CDNMK9MZBATGYNZY1CFKK	\N	pset_01KZ6CDNMM80TDKPN2NN3S6HJJ	inr	{"value": "2222", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	2222	\N	\N	\N	\N
price_01KZ6CDNMMX2CQE3ENG9KRD9R2	\N	pset_01KZ6CDNMNSH5724KCTBQDFGBJ	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNMNWW9XAQ4WENH57G2Q	\N	pset_01KZ6CDNMPTP460QMTG1AFYKFS	inr	{"value": "1899", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	1899	\N	\N	\N	\N
price_01KZ6CDNMPWH81YETAJDF0BMK1	\N	pset_01KZ6CDNMQ6EZ34R9B7JACVWHN	inr	{"value": "799", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	799	\N	\N	\N	\N
price_01KZ6CDNMQGFRK9J809378PMCK	\N	pset_01KZ6CDNMQ7HGG5G3XKEC79Q15	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNMRQ7236R3M2ZSNX83W	\N	pset_01KZ6CDNMR0YMP6C30YHJBQF5B	inr	{"value": "1499", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	1499	\N	\N	\N	\N
price_01KZ6CDNMSCXQ33XE5JJKGZ943	\N	pset_01KZ6CDNMSVQW1BR6Q91CYXY2Z	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNMTZE01GZCTK5W7680J	\N	pset_01KZ6CDNMTZ967FXA6X3K2XY6V	inr	{"value": "1699", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	1699	\N	\N	\N	\N
price_01KZ6CDNMV5FH2VGEM4D44YHJ3	\N	pset_01KZ6CDNMVP7B1BJ1T7XJGM7SR	inr	{"value": "899", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	899	\N	\N	\N	\N
price_01KZ6CDNMV2C0XAY9KMYVX7N94	\N	pset_01KZ6CDNMV8ZSPN02WQ1YYTY89	inr	{"value": "1699", "precision": 20}	0	2026-08-04 12:36:51.013+00	2026-08-04 12:36:51.013+00	\N	\N	1699	\N	\N	\N	\N
price_01KZ6CDNMW820JF8595THYBZGB	\N	pset_01KZ6CDNMW4PP8ZMTCMS9QRNBQ	inr	{"value": "249", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	249	\N	\N	\N	\N
price_01KZ6CDNMXP8E7YBHRX74VT21T	\N	pset_01KZ6CDNMY7DXQRMZDF54K55C0	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNMYNYXYY4R5NZDRX683	\N	pset_01KZ6CDNMZTTN626A0EV8YNF91	inr	{"value": "499", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	499	\N	\N	\N	\N
price_01KZ6CDNMZS9XN3QSZZ3EGKG54	\N	pset_01KZ6CDNMZ1980NA0T4YFFJAPC	inr	{"value": "499", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	499	\N	\N	\N	\N
price_01KZ6CDNN0T0C2W3V4NKTN01YX	\N	pset_01KZ6CDNN09ZMSWZQGNZK02JVG	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNN1Y0EXV1QTHGWGDXHS	\N	pset_01KZ6CDNN1SRK5FJZ03M4Y5XT4	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	699	\N	\N	\N	\N
price_01KZ6CDNN2P75DTX3PARN7EME0	\N	pset_01KZ6CDNN2MHWGP8MJEAVAA4NK	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNN31A213QCG0R6WQ0VZ	\N	pset_01KZ6CDNN3VWQE0EHKFDXG5X39	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNN3BYVHED7VV4QME1QE	\N	pset_01KZ6CDNN46J6A1QKYA2T5AM9Z	inr	{"value": "1499", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	1499	\N	\N	\N	\N
price_01KZ6CDNN4BCWT42JCC7JJ7RSM	\N	pset_01KZ6CDNN4YNHEX63NGCZW6ZJW	inr	{"value": "1699", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.014+00	\N	\N	1699	\N	\N	\N	\N
price_01KZ6CDNN580708E300XF7CYE0	\N	pset_01KZ6CDNN519PR8DVNDJ7TYWDE	inr	{"value": "2399", "precision": 20}	0	2026-08-04 12:36:51.014+00	2026-08-04 12:36:51.015+00	\N	\N	2399	\N	\N	\N	\N
price_01KZ6CDNN6MYT75WBT4CWEGQ75	\N	pset_01KZ6CDNN64KRNBB54GNV1HR9A	inr	{"value": "1899", "precision": 20}	0	2026-08-04 12:36:51.015+00	2026-08-04 12:36:51.015+00	\N	\N	1899	\N	\N	\N	\N
price_01KZ6CDNN67PAYWBFCYJ15RPKZ	\N	pset_01KZ6CDNN7RHX5E7VZ1F5T6614	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.015+00	2026-08-04 12:36:51.016+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNN7JGP85DHPW7MMDTTT	\N	pset_01KZ6CDNN8JEEZWKPA0TANWJKB	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.016+00	2026-08-04 12:36:51.016+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNN9F5SG41V8MRB74R7G	\N	pset_01KZ6CDNN935J5F65YZH79HQQN	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.016+00	2026-08-04 12:36:51.016+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNANPFKBG7K9D0JMZ9R	\N	pset_01KZ6CDNNAPFEWG2A5HQ3ZDGDJ	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.016+00	2026-08-04 12:36:51.016+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNBRSPVZ8ECWN1H15AX	\N	pset_01KZ6CDNNB06XXGS5YGD8500WD	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.016+00	2026-08-04 12:36:51.016+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNCNRV1AYM240QKC9QF	\N	pset_01KZ6CDNNCRVGY5Q4RVS5DTSMD	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.016+00	2026-08-04 12:36:51.016+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNDQPDB203BJFTZFQZB	\N	pset_01KZ6CDNNE41Y027QW7WMMTHHF	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNFFFKP9DRA381N9086	\N	pset_01KZ6CDNNF7D07TN9080SZ8KXX	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNG5HEPK2HHXYAKD2DJ	\N	pset_01KZ6CDNNGAX3JD6W9E15Q8XHV	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNHFV6RWEFAC8ZXWK1C	\N	pset_01KZ6CDNNHJ7VZ46S98ZS1TW1Q	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNJZ2EKZSCWT8154TFM	\N	pset_01KZ6CDNNJ5YEMRP3Y067B9ZSQ	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNK68WBRB6QK6C2JVJ1	\N	pset_01KZ6CDNNK545FEKRCD12KAPHC	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNM1AMS2NX743PENKGA	\N	pset_01KZ6CDNNMZF22XSQ22QK8000B	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNN6Z65VKSS1MF8TEKQ	\N	pset_01KZ6CDNNNZ1KHTKKD6Z3YENZV	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNPJW63YW41ZBEN763Z	\N	pset_01KZ6CDNNPZETNDY6QWH647R09	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNQAGHP3ND3C1WV6D1Z	\N	pset_01KZ6CDNNR3JGPV12PQFYBQY1W	inr	{"value": "999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6CDNNR4ZW5C75RRMKB8ZA9	\N	pset_01KZ6CDNNSRVHF4WG29TSKD5A7	inr	{"value": "1399", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	1399	\N	\N	\N	\N
price_01KZ6CDNNSGQ5DZWK8YR1468YT	\N	pset_01KZ6CDNNXZ0AF5A8R1PCE2S0J	inr	{"value": "1999", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ6CDNNYPZFEV1ZSYGGP58KP	\N	pset_01KZ6CDNNYENYC42ZBSNDHF1HD	inr	{"value": "699", "precision": 20}	0	2026-08-04 12:36:51.017+00	2026-08-04 12:36:51.017+00	\N	\N	699	\N	\N	\N	\N
price_01KZ4ZYA9XCJW37NNSGD925VMD	\N	pset_01KZ4ZYAA45FQ0CPRFW5VHD35Y	inr	{"value": "2000", "precision": 20}	0	2026-08-03 23:39:30.51+00	2026-08-04 12:40:32.529+00	2026-08-04 12:40:32.496+00	\N	2000	\N	\N	\N	\N
price_01KZ4ZYA9YN6NGX4H9QXMNN0KX	\N	pset_01KZ4ZYAA45FQ0CPRFW5VHD35Y	usd	{"value": "3000", "precision": 20}	0	2026-08-03 23:39:30.511+00	2026-08-04 12:40:32.53+00	2026-08-04 12:40:32.496+00	\N	3000	\N	\N	\N	\N
price_01KZ4ZYAA36KXBRCHF616JXVC9	\N	pset_01KZ4ZYAA45FQ0CPRFW5VHD35Y	inr	{"value": "3000", "precision": 20}	1	2026-08-03 23:39:30.512+00	2026-08-04 12:40:32.53+00	2026-08-04 12:40:32.496+00	\N	3000	\N	\N	\N	\N
price_01KZ4ZYAA6STRMVQ0BY96SZ043	\N	pset_01KZ4ZYAABYMV6PEV1N0KV2YDY	inr	{"value": "20002", "precision": 20}	0	2026-08-03 23:39:30.513+00	2026-08-04 12:40:32.62+00	2026-08-04 12:40:32.496+00	\N	20002	\N	\N	\N	\N
price_01KZ4ZYAA7T2E7SMK2Q5KYN2XR	\N	pset_01KZ4ZYAABYMV6PEV1N0KV2YDY	usd	{"value": "3999", "precision": 20}	0	2026-08-03 23:39:30.513+00	2026-08-04 12:40:32.62+00	2026-08-04 12:40:32.496+00	\N	3999	\N	\N	\N	\N
price_01KZ4ZYAA9VSCKANN04F7Y41S4	\N	pset_01KZ4ZYAABYMV6PEV1N0KV2YDY	inr	{"value": "2000", "precision": 20}	1	2026-08-03 23:39:30.513+00	2026-08-04 12:40:32.621+00	2026-08-04 12:40:32.496+00	\N	2000	\N	\N	\N	\N
price_01KZ6WJVP2DBNSXZT32W26XMPX	\N	pset_01KZ6WJVP2HVKJ0BEP47GQ3PQ3	inr	{"value": "1999", "precision": 20}	0	2026-08-04 17:19:18.211+00	2026-08-04 17:19:18.211+00	\N	\N	1999	\N	\N	\N	\N
price_01KYYM139ZFR9NESKAB7ZRXCYZ	\N	pset_01KYYM139ZCKKH87382SWXXM2B	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.58+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM139ZN06H8E80MG2BJ7S4	\N	pset_01KYYM139ZCKKH87382SWXXM2B	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.58+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A02JGBP48Z0CJYFZKA	\N	pset_01KYYM13A1DQHD2KTWQPQ8SVEN	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.608+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A1M65R9N3Q2X9ZWP0Y	\N	pset_01KYYM13A1DQHD2KTWQPQ8SVEN	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.608+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A2PJ2B1DGHFSS6ASSY	\N	pset_01KYYM13A3ZTAMWR05QTY3DXKB	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.632+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A2JFM2BMJ411S6JAEV	\N	pset_01KYYM13A3ZTAMWR05QTY3DXKB	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.632+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A3GDX66S9E8F3VX5VN	\N	pset_01KYYM13A4ZEYEJAT7XJEGH31M	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.655+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A3BK27HCE43M83RBMT	\N	pset_01KYYM13A4ZEYEJAT7XJEGH31M	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.655+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A4RPTNM18RBGGV4R3N	\N	pset_01KYYM13A52R22MTK2HG0XMGZA	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.68+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A56FSZEEFF6359BYFM	\N	pset_01KYYM13A52R22MTK2HG0XMGZA	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.68+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A6HFQ1CAXW005W9VV5	\N	pset_01KYYM13A6V5WG03MMKC2RKWW5	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.702+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A66F9X6G0M9Q3SF8H7	\N	pset_01KYYM13A6V5WG03MMKC2RKWW5	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.702+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A708XKZ615STM29Y9F	\N	pset_01KYYM13A8PYJ8D9N438SJ39AX	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.727+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A7Y06KAJAEV1VC0E5D	\N	pset_01KYYM13A8PYJ8D9N438SJ39AX	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.727+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KYYM13A87WNMQT2K73QKWXRG	\N	pset_01KYYM13A936N58HMTFK4YCGBR	eur	{"value": "10", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.749+00	2026-08-04 17:20:30.567+00	\N	10	\N	\N	\N	\N
price_01KYYM13A9G4RRX2RV34DXC9TA	\N	pset_01KYYM13A936N58HMTFK4YCGBR	usd	{"value": "15", "precision": 20}	0	2026-08-01 12:15:52.152+00	2026-08-04 17:20:30.749+00	2026-08-04 17:20:30.567+00	\N	15	\N	\N	\N	\N
price_01KZ6Y4FYH179EBRSXVAX0J3WD	\N	pset_01KZ6Y4FYJMV63HRYPHHA230T3	inr	{"value": "999", "precision": 20}	0	2026-08-04 17:46:24.595+00	2026-08-04 17:46:24.595+00	\N	\N	999	\N	\N	\N	\N
price_01KZ6Y4FYJ78C911AYZG4ND5HE	\N	pset_01KZ6Y4FYJMV63HRYPHHA230T3	inr	{"value": "999", "precision": 20}	1	2026-08-04 17:46:24.595+00	2026-08-04 17:46:24.595+00	\N	\N	999	\N	\N	\N	\N
price_01KZ7FWZD5X5WA0HS3VGRVA8NB	\N	pset_01KZ7FWZD6A2EJKKD32PG678N5	inr	{"value": "999", "precision": 20}	0	2026-08-04 22:56:52.646+00	2026-08-04 22:56:52.646+00	\N	\N	999	\N	\N	\N	\N
price_01KZ7G00C77GCAN5CGJTA2FXK5	\N	pset_01KZ7G00C9T9GRKTERKNQ0AKY9	inr	{"value": "1399", "precision": 20}	0	2026-08-04 22:58:31.945+00	2026-08-04 22:58:31.945+00	\N	\N	1399	\N	\N	\N	\N
price_01KZ7G00C9N2QKB1J1GS4GRSX9	\N	pset_01KZ7G00C9T9GRKTERKNQ0AKY9	inr	{"value": "1399", "precision": 20}	1	2026-08-04 22:58:31.945+00	2026-08-04 22:58:31.945+00	\N	\N	1399	\N	\N	\N	\N
price_01KZ7G0ZNW3XMAR4C2FSVFTSBW	\N	pset_01KZ7G0ZNWPDRATGA1TQ0KV501	inr	{"value": "1999", "precision": 20}	0	2026-08-04 22:59:03.997+00	2026-08-04 22:59:03.997+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ7G0ZNWK1F0P0RRRA9GWCTT	\N	pset_01KZ7G0ZNWPDRATGA1TQ0KV501	inr	{"value": "1999", "precision": 20}	1	2026-08-04 22:59:03.997+00	2026-08-04 22:59:03.997+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ7G1RJMG4416TM6WFVPWDMN	\N	pset_01KZ7G1RJNKD7G9NKJ1T32WW3W	inr	{"value": "2499", "precision": 20}	0	2026-08-04 22:59:29.493+00	2026-08-04 22:59:29.493+00	\N	\N	2499	\N	\N	\N	\N
price_01KZ7G1RJMES28XHHJT1J6MZQ5	\N	pset_01KZ7G1RJNKD7G9NKJ1T32WW3W	inr	{"value": "2499", "precision": 20}	1	2026-08-04 22:59:29.493+00	2026-08-04 22:59:29.493+00	\N	\N	2499	\N	\N	\N	\N
price_01KZ7G2M2SCNCP3Y379MES65H4	\N	pset_01KZ7G2M2TG78ZM1094EW3EECX	inr	{"value": "999", "precision": 20}	0	2026-08-04 22:59:57.659+00	2026-08-04 22:59:57.659+00	\N	\N	999	\N	\N	\N	\N
price_01KZ7G2M2T2ZHZ1Q5DWAJB9NVY	\N	pset_01KZ7G2M2TG78ZM1094EW3EECX	inr	{"value": "999", "precision": 20}	1	2026-08-04 22:59:57.659+00	2026-08-04 22:59:57.659+00	\N	\N	999	\N	\N	\N	\N
price_01KZ7G3DWVW6K6EC7VRT4X3JMQ	\N	pset_01KZ7G3DWW9CS6ZRVZGB2XDDK7	inr	{"value": "1399", "precision": 20}	0	2026-08-04 23:00:24.092+00	2026-08-04 23:00:24.092+00	\N	\N	1399	\N	\N	\N	\N
price_01KZ7G3DWWV57R0P206ABGBHHT	\N	pset_01KZ7G3DWW9CS6ZRVZGB2XDDK7	inr	{"value": "1399", "precision": 20}	1	2026-08-04 23:00:24.092+00	2026-08-04 23:00:24.092+00	\N	\N	1399	\N	\N	\N	\N
price_01KZ7G466BGCSE0RHVP0VZDVES	\N	pset_01KZ7G466C0XTY9TNGAYJC5M74	inr	{"value": "1999", "precision": 20}	0	2026-08-04 23:00:48.973+00	2026-08-04 23:00:48.973+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ7G466CWYT7KJK8R98AMJA3	\N	pset_01KZ7G466C0XTY9TNGAYJC5M74	inr	{"value": "1999", "precision": 20}	1	2026-08-04 23:00:48.973+00	2026-08-04 23:00:48.973+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ7G55N4S5CNCWQ8YGNZYRGM	\N	pset_01KZ7G55N5C987261BEKQF16D3	inr	{"value": "2499", "precision": 20}	0	2026-08-04 23:01:21.19+00	2026-08-04 23:01:21.19+00	\N	\N	2499	\N	\N	\N	\N
price_01KZ7G55N5FWXZ0G1A521X727M	\N	pset_01KZ7G55N5C987261BEKQF16D3	inr	{"value": "2499", "precision": 20}	1	2026-08-04 23:01:21.19+00	2026-08-04 23:01:21.19+00	\N	\N	2499	\N	\N	\N	\N
price_01KZ8XR8MDRCFAESHGKMNVKY0Y	\N	pset_01KZ8XR8MJH5M9M0PBRECGC6DR	inr	{"value": "1999", "precision": 20}	0	2026-08-05 12:18:12.757+00	2026-08-05 12:18:12.757+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8XR8MHQWZCG0W2N0D6SC0H	\N	pset_01KZ8XR8MJH5M9M0PBRECGC6DR	inr	{"value": "1999", "precision": 20}	1	2026-08-05 12:18:12.757+00	2026-08-05 12:18:12.757+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8XZHN3ANJEG0NCVYP1BCXG	\N	pset_01KZ8XZHN72K3KKVGC31NBVKK3	inr	{"value": "1999", "precision": 20}	0	2026-08-05 12:22:11.369+00	2026-08-05 12:22:11.369+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8XZHN6R3P79KVTZ440EV7G	\N	pset_01KZ8XZHN72K3KKVGC31NBVKK3	inr	{"value": "1999", "precision": 20}	1	2026-08-05 12:22:11.37+00	2026-08-05 12:22:11.37+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8Y143ZP5DMBKWVSGFTEG3H	\N	pset_01KZ8Y14442HDN7BHB1XXP97KY	inr	{"value": "1999", "precision": 20}	0	2026-08-05 12:23:03.045+00	2026-08-05 12:23:03.045+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8Y1443JXYCETE21P64FW9H	\N	pset_01KZ8Y14442HDN7BHB1XXP97KY	inr	{"value": "1999", "precision": 20}	1	2026-08-05 12:23:03.046+00	2026-08-05 12:23:03.046+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8Y1YWKA1A8WY5569R360FW	\N	pset_01KZ8Y1YWRWCKRP4QHP4BCDV5N	inr	{"value": "1999", "precision": 20}	0	2026-08-05 12:23:30.458+00	2026-08-05 12:23:30.458+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8Y1YWQ1AGA7CHAA1N5W51S	\N	pset_01KZ8Y1YWRWCKRP4QHP4BCDV5N	inr	{"value": "1999", "precision": 20}	1	2026-08-05 12:23:30.458+00	2026-08-05 12:23:30.458+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8Y2PDND2FJZ1ZW91V5BEDA	\N	pset_01KZ8Y2PDT81JKP3TE6W8T14V0	inr	{"value": "1999", "precision": 20}	0	2026-08-05 12:23:54.556+00	2026-08-05 12:23:54.556+00	\N	\N	1999	\N	\N	\N	\N
price_01KZ8Y2PDSCPSDXHYXADW3EAW3	\N	pset_01KZ8Y2PDT81JKP3TE6W8T14V0	inr	{"value": "1999", "precision": 20}	1	2026-08-05 12:23:54.556+00	2026-08-05 12:23:54.556+00	\N	\N	1999	\N	\N	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at, metadata) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01KYYM114XTYX6S07ZDH4WK8HW	currency_code	eur	f	2026-08-01 12:15:49.919+00	2026-08-01 12:15:49.919+00	\N
prpref_01KYYM11BZ35XHNCADD2NGBN49	region_id	reg_01KYYM116XC444G5JS3BHE5HHB	f	2026-08-01 12:15:50.144+00	2026-08-01 12:15:50.144+00	\N
prpref_01KZ4VHGZ2SS5P9T43BAH7T3H0	currency_code	inr	f	2026-08-03 22:22:37.029+00	2026-08-03 23:19:38.081+00	\N
prpref_01KYYM114YGFEJXAB9VZEPSM40	currency_code	usd	f	2026-08-01 12:15:49.92+00	2026-08-03 23:19:40.318+00	\N
prpref_01KZ7F0JTCKTPJWPAZ3SW1SXKW	region_id	reg_01KZ7F0JSMXZXMJNNA4W7HRQTX	f	2026-08-04 22:41:22.252+00	2026-08-04 22:41:22.252+00	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01KYYM122DG7TABNMNECCMQTJ0	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KYYM122EQ0H0JYJ23CCVDHSR	2026-08-01 12:15:50.871+00	2026-08-01 12:15:50.871+00	\N	region_id	eq
prule_01KYYM122HCB113P9K7H6K5MJF	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KYYM122J760BASE5B93YP5MM	2026-08-01 12:15:50.872+00	2026-08-01 12:15:50.872+00	\N	region_id	eq
prule_01KZ4ZYAA2ASSZ79MM8WY76994	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ4ZYAA36KXBRCHF616JXVC9	2026-08-03 23:39:30.512+00	2026-08-04 12:40:32.58+00	2026-08-04 12:40:32.496+00	region_id	eq
prule_01KZ4ZYAA9B6M9PPG98P1XS6ZG	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ4ZYAA9VSCKANN04F7Y41S4	2026-08-03 23:39:30.513+00	2026-08-04 12:40:32.671+00	2026-08-04 12:40:32.496+00	region_id	eq
prule_01KZ6Y4FYJ280Y8K80ZA3ZXS16	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ6Y4FYJ78C911AYZG4ND5HE	2026-08-04 17:46:24.595+00	2026-08-04 17:46:24.595+00	\N	region_id	eq
prule_01KZ7G00C8GNYZXQQJJHJVHDVC	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G00C9N2QKB1J1GS4GRSX9	2026-08-04 22:58:31.945+00	2026-08-04 22:58:31.945+00	\N	region_id	eq
prule_01KZ7G0ZNWNHNJS6R1FAZ04KET	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G0ZNWK1F0P0RRRA9GWCTT	2026-08-04 22:59:03.997+00	2026-08-04 22:59:03.997+00	\N	region_id	eq
prule_01KZ7G1RJM973GXZ97ZD0902BZ	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G1RJMES28XHHJT1J6MZQ5	2026-08-04 22:59:29.493+00	2026-08-04 22:59:29.493+00	\N	region_id	eq
prule_01KZ7G2M2TG4M2BR5G9P9SW0Y9	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G2M2T2ZHZ1Q5DWAJB9NVY	2026-08-04 22:59:57.659+00	2026-08-04 22:59:57.659+00	\N	region_id	eq
prule_01KZ7G3DWW26FMSC0D4EV2YYZY	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G3DWWV57R0P206ABGBHHT	2026-08-04 23:00:24.092+00	2026-08-04 23:00:24.092+00	\N	region_id	eq
prule_01KZ7G466CXAMFJC29ENA9WMMY	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G466CWYT7KJK8R98AMJA3	2026-08-04 23:00:48.973+00	2026-08-04 23:00:48.973+00	\N	region_id	eq
prule_01KZ7G55N5EWVBNF63F4ZHEY4N	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ7G55N5FWXZ0G1A521X727M	2026-08-04 23:01:21.19+00	2026-08-04 23:01:21.19+00	\N	region_id	eq
prule_01KZ8XR8MGMAX40YPV3MV3070F	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ8XR8MHQWZCG0W2N0D6SC0H	2026-08-05 12:18:12.76+00	2026-08-05 12:18:12.76+00	\N	region_id	eq
prule_01KZ8XZHN63521BM9Y3T7ASXRS	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ8XZHN6R3P79KVTZ440EV7G	2026-08-05 12:22:11.37+00	2026-08-05 12:22:11.37+00	\N	region_id	eq
prule_01KZ8Y1442FB0Y7271X7969VEC	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ8Y1443JXYCETE21P64FW9H	2026-08-05 12:23:03.047+00	2026-08-05 12:23:03.047+00	\N	region_id	eq
prule_01KZ8Y1YWNVBP5DV28WT88KCNE	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ8Y1YWQ1AGA7CHAA1N5W51S	2026-08-05 12:23:30.458+00	2026-08-05 12:23:30.458+00	\N	region_id	eq
prule_01KZ8Y2PDRDBGGQ2VFN62WV70S	reg_01KYYM116XC444G5JS3BHE5HHB	0	price_01KZ8Y2PDSCPSDXHYXADW3EAW3	2026-08-05 12:23:54.556+00	2026-08-05 12:23:54.556+00	\N	region_id	eq
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01KYYM122E03VWTGPJNZ3VCJR0	2026-08-01 12:15:50.869+00	2026-08-01 12:15:50.869+00	\N
pset_01KYYM122KDCQ6M2Q7G20B37NM	2026-08-01 12:15:50.869+00	2026-08-01 12:15:50.869+00	\N
pset_01KZ6CDNKK5MNHWR8400KGPC3P	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKMQ5W80136AV6AX19Z	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKN23R9BC98G8XBA1V0	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKSWZR2TSBGZ3GPA0AH	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKTKK34WD04BP2R2Y0M	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKV8Y9TZN1YNJ4G4CWB	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKWXMVWDQXK7TW6C5PM	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNKX87AAHCP43EJEJQ6T	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM2PYC1WFK74P8B0KE6	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM3SJ2DXE9YXY6FYRG0	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM3ETYSERJ2JCP0ZYHR	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM4Q64A2M2XBE3W7Q5D	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM57VKQD39962B4YRAH	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM66W7NQSJHNH2ECZA2	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM6F6P2BHKM1CG3NYT6	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM778PVGESD65Y2TFVJ	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNM95KKRF23Z0AXJC54E	2026-08-04 12:36:51.009+00	2026-08-04 12:36:51.009+00	\N
pset_01KZ6CDNMATHEP453YDRFTSG9R	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMBWYSES2647Q638K89	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMCW0JPX8R3J5B4DC44	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMD8ZBSXCT3EQRH9PPS	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMEQHDJSXM7TCXTZ5JR	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMF3JK1EZMB28AVNS22	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMGCWGJVDGKPCJN8WHQ	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMHAZPFCMFVFVK8ND2H	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMHWX6ZCV8MN22GGYSR	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMJBZ4NGMJZ1C3Z689M	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMKJ4BK5T4M6ZR0BZ2Z	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMM80TDKPN2NN3S6HJJ	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMNSH5724KCTBQDFGBJ	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMPTP460QMTG1AFYKFS	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMQ6EZ34R9B7JACVWHN	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMQ7HGG5G3XKEC79Q15	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMR0YMP6C30YHJBQF5B	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMSVQW1BR6Q91CYXY2Z	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMTZ967FXA6X3K2XY6V	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMVP7B1BJ1T7XJGM7SR	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMV8ZSPN02WQ1YYTY89	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMW4PP8ZMTCMS9QRNBQ	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMY7DXQRMZDF54K55C0	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMZTTN626A0EV8YNF91	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNMZ1980NA0T4YFFJAPC	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN09ZMSWZQGNZK02JVG	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN1SRK5FJZ03M4Y5XT4	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN2MHWGP8MJEAVAA4NK	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN3VWQE0EHKFDXG5X39	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN46J6A1QKYA2T5AM9Z	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN4YNHEX63NGCZW6ZJW	2026-08-04 12:36:51.01+00	2026-08-04 12:36:51.01+00	\N
pset_01KZ6CDNN519PR8DVNDJ7TYWDE	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNN64KRNBB54GNV1HR9A	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNN7RHX5E7VZ1F5T6614	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNN8JEEZWKPA0TANWJKB	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNN935J5F65YZH79HQQN	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNAPFEWG2A5HQ3ZDGDJ	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNB06XXGS5YGD8500WD	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNCRVGY5Q4RVS5DTSMD	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNE41Y027QW7WMMTHHF	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNF7D07TN9080SZ8KXX	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNGAX3JD6W9E15Q8XHV	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNHJ7VZ46S98ZS1TW1Q	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNJ5YEMRP3Y067B9ZSQ	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNK545FEKRCD12KAPHC	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNMZF22XSQ22QK8000B	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNNZ1KHTKKD6Z3YENZV	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNPZETNDY6QWH647R09	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNR3JGPV12PQFYBQY1W	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNSRVHF4WG29TSKD5A7	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNXZ0AF5A8R1PCE2S0J	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ6CDNNYENYC42ZBSNDHF1HD	2026-08-04 12:36:51.011+00	2026-08-04 12:36:51.011+00	\N
pset_01KZ4ZYAA45FQ0CPRFW5VHD35Y	2026-08-03 23:39:30.509+00	2026-08-04 12:40:32.497+00	2026-08-04 12:40:32.496+00
pset_01KZ4ZYAABYMV6PEV1N0KV2YDY	2026-08-03 23:39:30.51+00	2026-08-04 12:40:32.58+00	2026-08-04 12:40:32.496+00
pset_01KZ6WJVP2HVKJ0BEP47GQ3PQ3	2026-08-04 17:19:18.211+00	2026-08-04 17:19:18.211+00	\N
pset_01KYYM139ZCKKH87382SWXXM2B	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.568+00	2026-08-04 17:20:30.567+00
pset_01KYYM13A1DQHD2KTWQPQ8SVEN	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.596+00	2026-08-04 17:20:30.567+00
pset_01KYYM13A3ZTAMWR05QTY3DXKB	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.622+00	2026-08-04 17:20:30.567+00
pset_01KYYM13A4ZEYEJAT7XJEGH31M	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.644+00	2026-08-04 17:20:30.567+00
pset_01KYYM13AJ4CHK4RCBRVA5JW7T	2026-08-01 12:15:52.152+00	2026-08-04 17:20:33.416+00	2026-08-04 17:20:33.416+00
pset_01KYYM13AK1M83SRFKDV0EZ92J	2026-08-01 12:15:52.152+00	2026-08-04 17:20:33.44+00	2026-08-04 17:20:33.416+00
pset_01KYYM13ANWE45PGS6FTAFW891	2026-08-01 12:15:52.152+00	2026-08-04 17:20:33.467+00	2026-08-04 17:20:33.416+00
pset_01KYYM13AP1VJ8WS9JV8HW5V0Y	2026-08-01 12:15:52.152+00	2026-08-04 17:20:33.491+00	2026-08-04 17:20:33.416+00
pset_01KYYM13AEJ76N13RV163E3CYY	2026-08-01 12:15:52.152+00	2026-08-04 17:20:36.711+00	2026-08-04 17:20:36.711+00
pset_01KYYM13AFW7BYET0YK90NT4G5	2026-08-01 12:15:52.152+00	2026-08-04 17:20:36.737+00	2026-08-04 17:20:36.711+00
pset_01KYYM13AGMZJPNVK2FTCTW0T7	2026-08-01 12:15:52.152+00	2026-08-04 17:20:36.769+00	2026-08-04 17:20:36.711+00
pset_01KYYM13AHVA0F4G30PJQ3ZC8R	2026-08-01 12:15:52.152+00	2026-08-04 17:20:36.798+00	2026-08-04 17:20:36.711+00
pset_01KYYM13AARN1HQA2JFEN5VQTP	2026-08-01 12:15:52.151+00	2026-08-04 17:20:40.436+00	2026-08-04 17:20:40.436+00
pset_01KYYM13ABACPTPSKXKAFH29K4	2026-08-01 12:15:52.151+00	2026-08-04 17:20:40.459+00	2026-08-04 17:20:40.436+00
pset_01KYYM13ACW862P4AFH0NRF18R	2026-08-01 12:15:52.152+00	2026-08-04 17:20:40.483+00	2026-08-04 17:20:40.436+00
pset_01KYYM13ADYCWVZ4GXXSNX25KZ	2026-08-01 12:15:52.152+00	2026-08-04 17:20:40.507+00	2026-08-04 17:20:40.436+00
pset_01KZ6CDNKNQK3R2RZ6Z0ZGE5CZ	2026-08-04 12:36:51.009+00	2026-08-04 22:55:43.909+00	2026-08-04 22:55:43.907+00
pset_01KZ6CDNKP3M9VPP6T9BBP0NBW	2026-08-04 12:36:51.009+00	2026-08-04 22:55:48.638+00	2026-08-04 22:55:48.637+00
pset_01KZ6CDNKQ01CRDP40M8VV0RH1	2026-08-04 12:36:51.009+00	2026-08-04 22:55:53.06+00	2026-08-04 22:55:53.06+00
pset_01KZ6CDNKR9JDVRZGY7N3X8EXB	2026-08-04 12:36:51.009+00	2026-08-04 22:55:56.836+00	2026-08-04 22:55:56.836+00
pset_01KZ6CDNKYPWF5QVXBMZVZZPMV	2026-08-04 12:36:51.009+00	2026-08-05 12:16:54.488+00	2026-08-05 12:16:54.485+00
pset_01KZ6CDNKZ9G9XRVA00X38W1X1	2026-08-04 12:36:51.009+00	2026-08-05 12:16:59.68+00	2026-08-05 12:16:59.679+00
pset_01KZ6CDNM0BB8YGVCRQCJVVNG4	2026-08-04 12:36:51.009+00	2026-08-05 12:17:04.133+00	2026-08-05 12:17:04.132+00
pset_01KZ6CDNM1HH2SXT0A72VEJ5P6	2026-08-04 12:36:51.009+00	2026-08-05 12:17:08.562+00	2026-08-05 12:17:08.561+00
pset_01KYYM13A52R22MTK2HG0XMGZA	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.669+00	2026-08-04 17:20:30.567+00
pset_01KYYM13A6V5WG03MMKC2RKWW5	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.692+00	2026-08-04 17:20:30.567+00
pset_01KYYM13A8PYJ8D9N438SJ39AX	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.718+00	2026-08-04 17:20:30.567+00
pset_01KYYM13A936N58HMTFK4YCGBR	2026-08-01 12:15:52.151+00	2026-08-04 17:20:30.741+00	2026-08-04 17:20:30.567+00
pset_01KZ6Y4FYJMV63HRYPHHA230T3	2026-08-04 17:46:24.595+00	2026-08-04 17:46:24.595+00	\N
pset_01KZ7FWZD6A2EJKKD32PG678N5	2026-08-04 22:56:52.646+00	2026-08-04 22:56:52.646+00	\N
pset_01KZ7G00C9T9GRKTERKNQ0AKY9	2026-08-04 22:58:31.945+00	2026-08-04 22:58:31.945+00	\N
pset_01KZ7G0ZNWPDRATGA1TQ0KV501	2026-08-04 22:59:03.997+00	2026-08-04 22:59:03.997+00	\N
pset_01KZ7G1RJNKD7G9NKJ1T32WW3W	2026-08-04 22:59:29.493+00	2026-08-04 22:59:29.493+00	\N
pset_01KZ7G2M2TG78ZM1094EW3EECX	2026-08-04 22:59:57.658+00	2026-08-04 22:59:57.658+00	\N
pset_01KZ7G3DWW9CS6ZRVZGB2XDDK7	2026-08-04 23:00:24.092+00	2026-08-04 23:00:24.092+00	\N
pset_01KZ7G466C0XTY9TNGAYJC5M74	2026-08-04 23:00:48.973+00	2026-08-04 23:00:48.973+00	\N
pset_01KZ7G55N5C987261BEKQF16D3	2026-08-04 23:01:21.19+00	2026-08-04 23:01:21.19+00	\N
pset_01KZ8XR8MJH5M9M0PBRECGC6DR	2026-08-05 12:18:12.756+00	2026-08-05 12:18:12.756+00	\N
pset_01KZ8XZHN72K3KKVGC31NBVKK3	2026-08-05 12:22:11.369+00	2026-08-05 12:22:11.369+00	\N
pset_01KZ8Y14442HDN7BHB1XXP97KY	2026-08-05 12:23:03.045+00	2026-08-05 12:23:03.045+00	\N
pset_01KZ8Y1YWRWCKRP4QHP4BCDV5N	2026-08-05 12:23:30.457+00	2026-08-05 12:23:30.457+00	\N
pset_01KZ8Y2PDT81JKP3TE6W8T14V0	2026-08-05 12:23:54.555+00	2026-08-05 12:23:54.555+00	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01KZ6CDKYXXTR7F86BCCC30ZR7	Pearl Dots	pearl-dots	\N	<p>Cute dots on your ears</p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-30-04h36m06s240.png?v=1727651270	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 19:31:04.072+00	\N	\N
prod_01KZ6CDKYY274F77R2WV1ZVGCH	Attract That Money Bracelet	queens-fortune	\N	<p>Wear it as you hustle, as you dream, as you visualise your goals.</p>\n<p>This stunning gold coin bracelet is more than just an accessory; it's a daily dose of manifestation magic. Every time you glance at your wrist, it serves as a powerful affirmation, reminding you that you are open and ready to receive abundance.</p>\n<p>The perfect addition to your stacking bracelet collection, this gold bracelet is a beautiful way to elevate your style while aligning yourself with prosperity.</p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_f32dd844-2712-4e7b-bdce-9f9fafaedc1b.jpg?v=1717249422	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 19:31:04.072+00	\N	\N
prod_01KYYM12HNB3B06MTFGRDQ6HER	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2026-08-01 12:15:51.413+00	2026-08-04 17:20:30.531+00	2026-08-04 17:20:30.531+00	\N
prod_01KYYM12HPCG0WKM9PV50YN7NH	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2026-08-01 12:15:51.415+00	2026-08-04 17:20:33.387+00	2026-08-04 17:20:33.386+00	\N
prod_01KYYM12HPFK3M2KARA0JVMBZV	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2026-08-01 12:15:51.415+00	2026-08-04 17:20:36.673+00	2026-08-04 17:20:36.673+00	\N
prod_01KYYM12HPNF1205QN0N30DVZ7	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2026-08-01 12:15:51.415+00	2026-08-04 17:20:40.404+00	2026-08-04 17:20:40.404+00	\N
prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ	Pencil	pencil		<p><strong>Founder’s note :</strong><br>Same DNA as <a href="https://strawb.in/products/swirly" target="_blank" rel="noopener">Swirly</a>, but with a lil extra twist—literally. This earring is all kinds of abstract and fun. Makes a great gift for someone who loves the unexpected. Feels cool, looks cooler. I wear this all the time. It looks like a sculpture ykwim. Compliments guaranteed.</p>	f	published	http://localhost:9000/static/1785863957932-IMG_4259.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	f	\N	2026-08-04 17:19:17.969+00	2026-08-04 18:10:09.948+00	\N	\N
prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ	Pearl Clasp	pearl-clasp	\N	<p><meta charset="utf-8"><span id="docs-internal-guid-0249b6dc-7fff-279d-eeec-59f41f8b970f">It’s a 2 piece set and it’s sooooo versatile. looks so minimal and pretty!</span></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7092_1.jpg?v=1753031411	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 18:10:09.946+00	\N	\N
prod_01KZ6CDKYX8WKS0VK0PA1MEV6X	Pearly	pearly	\N	<p>For the pearlies out there, wear it on one ear or both, you're gonna attract eyes</p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1459_40e95d40-7403-4b0f-86b9-7be13311b143.jpg?v=1726609188	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 18:10:09.946+00	\N	\N
prod_01KZ6CDKYY4A5TBFR2ETW7PBKE	Attract That Money Earrings	queens-blessing	\N	<p>These aren't just gold earrings or coin earrings; they're your personal prosperity charms.</p>\n<p>Rock these statement earrings as you chase your goals and manifest your dreams into reality. <br>These waterproof earrings are crafted to withstand your busy life, but it's your belief that unlocks their true power. Wear them with confidence and purpose, and watch the universe conspire to bring your desires to life.</p>\n<p data-sourcepos="3:1-3:130"><br><strong></strong></p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_7b9bb060-2b71-417b-8b07-c3e5e61c71e7.jpg?v=1717249512	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 18:10:09.946+00	\N	\N
prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	divansh	divansh	singh	thioehierfksjfsadfi sadfjksad;fjds;lfkjsadlkfads fdsfljksadf;sadjflsda;	f	published	http://localhost:9000/static/1785800369490-WIN_20260719_02_55_48_Pro.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2026-08-03 23:39:29.752+00	2026-08-04 12:40:32.415+00	2026-08-04 12:40:32.415+00	\N
prod_01KZ6CDKYYSXAKPSQNKY2A7W55	S Ring	s-ring	\N	<p><strong>Founder’s note :</strong><br>Big energy in one ring. Can’t go wrong with this one. I wear it when I want to feel like a boss. Adjustable = stress-free gifting. 10/10 recommend.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1460.jpg?v=1745090433	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 17:26:29.217+00	\N	\N
prod_01KZ6CDKYZYWXF8070GY5M3PCS	Sea Twins	sea-twins	\N	<p><strong>Founder’s note :</strong><br>I wore these on a beach day and got more compliments than the number of times I put on sunscreen. They're bold, fun, and totally give tropical chic. Gifting these? So smart. Especially for that one friend who plans outfits in advance. And yes, there's a matching necklace because we believe in full commitment to the look😌</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7756.jpg?v=1732804986	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 17:26:29.217+00	\N	\N
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	Double The Drama	double-drama	\N	<p><strong>Founder’s note :</strong><br>Life mein drama kam hai? Yeh lelo. Fixed. Double The Drama is sleek, golden, and basically made for turning heads. I love how they look luxe without trying too hard. Party fits, date nights, even dressing up denim—this one’s a vibe.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-08-01h06m12s468.jpg?v=1736279422	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 11:12:54.633+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYW57VVJNPN63K17BJQ	Old Money Rings	old-money-rings	\N	<p><strong>Founder’s note :</strong><br>One of our most thoughtful (and best-looking) pieces. This is a gift that means something. We made these for opposites—Siblings, couples, best friends. Whether you pair them or wear one solo, the design feels simple, stylish, and one of those pieces people always ask about.</p>\n<p> </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_9167.jpg?v=1760973405	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 17:26:29.217+00	\N	\N
prod_01KZ6CDKYPDQG0QDKT37MDDPA3	Caterpillar	caterpillar	\N	<p><strong>Founder’s note :</strong><br>These are our bestsellers—and once you wear one, you get why. The stones catch light so beautifully, and they add the perfect little glow to any outfit. I have one in every color (not even kidding), and they’re honestly one of the best things we’ve made. Easy to wear, easy to gift, always gets compliments.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_2872.jpg?v=1746046186	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ768K05VPN64CJV28KQKGBC	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:24:13.932+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYP0NXWRGS0S9F7YK07	Cherry Earrings	cherry-earrings	\N	<p>Founder's Note :<br>A lil bit of sweetness! These sit just right on the ear—light, playful, and so fresh. The kind of piece that makes people go “omg where’d you get that?” Pairs <em data-start="199" data-end="210">perfectly</em> with our cherry necklace for that juicy little set moment.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_May_9_2025_12_05_00_AM.jpg?v=1747321638	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:29:06.989+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB	Starry Love	starry-love	\N	<p><strong>Founder’s note :</strong><br>Inspired by Van Gogh’s most iconic painting, this one’s for the romantics, the dreamers, the art lovers. Dreamy, meaningful, and honestly—such a romantic gift. The blue and gold swirl feels like something out of a story. Bonus: they’re adjustable, so don’t stress the size. Just surprise her. She’ll get it.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_May_20_2025_01_58_38_PM.png?v=1754222174	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 17:26:29.217+00	\N	\N
prod_01KZ6CDKZ0GNQN22M2K7B7N3SF	Swirly	swirly	\N	<p><strong>Founder’s note :</strong><br>Swirly is a googly woogly designed earring, there i said it. Totally not your basic hoop. I love how this one adds a statement without being too in-your-face. It’s such a smart gifting piece too—stylish, lightweight, and fits everyone’s vibe.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-11-02h26m31s497.jpg?v=1739973635	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 18:10:09.947+00	\N	\N
prod_01KZ6CDKYNR4MMKW0P0TKPM2EY	The Guardian	azure-guardian	\N	<p>The Guardian, a stunning evil eye pendant necklace.  More than just evil eye jewellery, it's your everyday shield against negativity.  Turn protection into a fashion statement. The Guardian's vibrant hues make a bold statement, while its symbolic meaning offers peace of mind.  This locket necklace is the perfect everyday essential for the modern woman.</p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_0bcebe9f-3485-43c7-a1ad-f825eaa4911b.jpg?v=1717248837	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76A05F5A855JCH5KCBCYZM	t	\N	2026-08-04 12:36:49.477+00	2026-08-05 11:07:17.917+00	\N	{"vendor": "vembley"}
prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	Fettuccine	fettuccine	\N	<p><strong>Founder’s note :</strong><br>Every girl needs a good snake chain. This one’s clean, sleek, and quietly bold. The kind of piece you don’t even realize you’re wearing—until someone compliments it. Once you find a good one, it becomes your go-to. Like this one did for me.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/f1.jpg?v=1747324240	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76A05F5A855JCH5KCBCYZM	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:48:36.553+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKZ1921PDG5W42Z4XBA6	Worly	worly	\N	<p><strong>Founder’s note :</strong><br>Same DNA as <a href="https://strawb.in/products/swirly" target="_blank" rel="noopener">Swirly</a>, but with a lil extra twist—literally. This earring is all kinds of abstract and fun. Makes a great gift for someone who loves the unexpected. Feels cool, looks cooler. I wear this all the time. It looks like a sculpture ykwim. Compliments guaranteed.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7879.jpg?v=1753033466	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.488+00	2026-08-04 18:10:09.948+00	\N	\N
prod_01KZ6CDKYST01Z3CFZ1PXH5C76	Heart Melt	heart-cord-set	\N	<p><strong>Founder’s note :</strong><br>Sabrina Carpenter wore something like this, and yes—it’s giving. Not for the faint of heart. This heart drips attitude. It’s dramatic, it’s versatile, and it absolutely stands out. Doubles as a necklace and earring. Icon behavior. Gift it only if she’s got that edge.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/hm2.jpg?v=1748473116	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.944+00	\N	\N
prod_01KZ6CDKZ0ZYP65PJVX991FY70	Void	void	\N	<p><strong>Founder’s note :</strong><br>It’s a black circle—simple. It’s for the days that feel blank, when the world is too loud and your heart is too quiet. When you’re not happy, not sad—just… floating. It doesn’t fix anything. But it sits with you. And that in itself is something. Makes a powerful gift for someone going through something—a soft kind of support. I’ve worn this one on hard days.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1880.jpg?v=1745089488	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.487+00	2026-08-04 18:10:09.948+00	\N	\N
prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F	Shape Shifter	shape-shifter	\N	<p><strong>Founder’s note :</strong><br>A literal shape shifter, allows you to accessorize any outfit of yours. You can style it high or low depending on your neckline—super chic, super versatile. Makes such a thoughtful (and unique!) gift. Definitely my top pick.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ss4.jpg?v=1747321364	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 18:10:09.947+00	\N	\N
prod_01KZ6CDKYT1JZ4CFG3QV6M39SC	Make A Statement	make-a-statement	\N	<p><strong>Founder’s note :</strong><br>The shape is so unique, and that soft pearly white just glows. I'm lowkey obsessed. It’s adjustable too, so perfect for gifting—even if you don’t know her ring size. <br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/mas.jpg?v=1725914277	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.944+00	\N	\N
prod_01KZ6CDKYVSGW61NNZPD4KXBWY	Oh! So Cute	oh-so-cute	\N	<p>FYI, bows are the new things so if you don’t have these, you’re probably missing out🎀</p>\n<p>One of a kind, we only have around 30 pieces of this beaut. It features an adorable ribbon bow and a tassel snake chain. </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-09-13-14h17m49s649.jpg?v=1726222740	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 18:10:09.945+00	\N	\N
prod_01KZ6CDKYN61S7DVMW2DEQXG56	Bamboo Bangle	bamboo-bangle	\N	<p><strong>Founder’s note :</strong><br>Easily one of my favorite bangles. It’s adjustable, which makes it perfect for gifting—but honestly? I’d keep this one for myself. Looks super elegant, gets compliments every time I wear it, and feels way more unique than your usual gold bangle. And yes, you’ll need a little help adjusting it, but once it’s on? Perfection.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Apr_22_2025_02_14_34_AM.jpg?v=1746044142	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ768K05VPN64CJV28KQKGBC	t	\N	2026-08-04 12:36:49.477+00	2026-08-04 22:46:14.49+00	\N	\N
prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	Blingers	blingers	\N	<p>It doesn't even need piercings. Best for this Diwali or any traditional outfit</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5298.png?v=1729988251	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76939CWWD3BS46NNTXRMQZ	t	\N	2026-08-04 12:36:49.477+00	2026-08-05 10:25:18.176+00	\N	\N
prod_01KZ6CDKYNFYQ8KEWXD75JHSMR	AND FOREVER	and-forever	\N	<p>This will last forever nai tho paisa wapis</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/WhatsApp_Image_2024-09-20_at_5.20.58_PM-2.jpg?v=1727391692	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	ptyp_01KZ76A05F5A855JCH5KCBCYZM	t	\N	2026-08-04 12:36:49.476+00	2026-08-05 11:04:19.129+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYPM773V64EKZDC8TZ3	Butterflies	butterflies	\N	<p data-sourcepos="5:1-5:112"><strong>Founder’s note :</strong><br>No piercings? No problem. I put these on and instantly felt like I needed a tiara. It looks like butterflies are literally floating on your ear. So lightweight you forget they’re on, but trust me—everyone else notices<br></p>\n<p> </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_1d465bc2-455b-4f12-be7b-bf1b79abdfc9.jpg?v=1717243588	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76939CWWD3BS46NNTXRMQZ	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:33:31.921+00	\N	{"vendor": "Vembley"}
prod_01KZ6CDKYR6NPKX84Y57F84V1Q	Golden Dots	golden-dots	\N	<p>Tiny golden dots on your ears that shimmers from far far away. Simple &amp; basic. </p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5925.jpg?v=1732091778	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.479+00	2026-08-05 12:50:43.124+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYR72K3JFDD9WRHXFMP	Forever Flower	forever-flower	\N	<p>A flower that lasts forever (not made out of plastic hehe). It's the perfect gift for a special someone or yourself ;)</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-20h35m40s196-2.jpg?v=1734460042	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76A05F5A855JCH5KCBCYZM	t	\N	2026-08-04 12:36:49.479+00	2026-08-05 12:52:40.975+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYRZ215S2ACPC8ER0DH	Everyday	everyday	\N	<p><strong>Founder’s note :</strong><br>The name says it all—‘Everyday’. She’ll wear these constantly, so gift them and be the reason she thinks of you every morning. I call these my no-brainer earrings. They go with everything, never feel too much, and that little crystal drop? Just the right amount of sparkle.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-01-31-00h21m24s584.jpg?v=1738264450	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:54:15.741+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYS41JESCZCY4BCM9FM	Golden Geometry	golden-geometry	\N	<p data-sourcepos="1:1-1:47">These pearl stud earrings are the perfect combination of minimalist elegance and geometric flair. The lustrous pearls are set in a simple, geometric design that is both modern and sophisticated. These earrings are versatile enough to be worn for any occasion, from a casual day out to a night on the town. </p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/3_e92b5ed0-dd03-4db3-9577-5db03502b0b4.jpg?v=1717249044	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.479+00	2026-08-05 12:56:08.207+00	\N	{"vendor": "vembley"}
prod_01KZ6CDKYSCZ5V05NQEKZQHW9B	Green Set	green-set	\N	<p>All things green </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Express-collage_2.png?v=1728068544	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	ptyp_01KZ76APX77E9WACSXDCJ7FSBS	t	\N	2026-08-04 12:36:49.48+00	2026-08-05 12:57:34.619+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYSH709KDZ998WH03F7	I'm Just a Girl	justagirl	\N	<p>We are simple girls, we see pearl we buy it, that's all there is to these pearl earrings🎀</p>\n<p>These are waterproof, anti-tarnish and cute as ever. One of our crowd favorites.</p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1-2.jpg?v=1725918446	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.943+00	\N	\N
prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM	White Set	white-set	\N	<p>Not being racist here but white goes with everything</p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/Express-collage_1.png?v=1728068006	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	\N	t	\N	2026-08-04 12:36:49.487+00	2026-08-04 19:31:04.073+00	\N	\N
prod_01KZ6CDKYNSVSVB52D31W5Z60T	Buckle Up	buckle-up	\N	<p>Cost of buckle up is 1299/-, pre-order cost is 699/-</p>\n<p>We took inspiration from unexpected places for this one ;)</p>\n<p>Buckle Up features a bold belt-buckle design, adding a touch of rebellious spirit to your everyday attire. It's where sleek sophistication meets industrial edge. This one is the perfect choice for those who crave statement bracelets that go beyond the ordinary. </p>\n<p> </p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_1e288065-e1ad-4fc4-80b7-afdb6a3a3ce5.jpg?v=1717244194	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ768K05VPN64CJV28KQKGBC	t	\N	2026-08-04 12:36:49.477+00	2026-08-05 11:08:57.414+00	\N	{"vandor": "tarohi"}
prod_01KZ6CDKYPP489B1SJAPJ484NC	Cherry	cherry	\N	<p><strong>Founder’s note :</strong><br>She’s the cherry on top—literally. I’ve worn it to brunch, the mall, and a FaceTime date and it always gets love. Everyone who’s got it has loved it. It’s got that awww, so cute! effect. I’d gift this to literally anyone, because everyone looks cute in it, no exceptions. <br>(we’ve also got matching earrings hehe)</p>\n<p> </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/cherry1.jpg?v=1749327131	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76A05F5A855JCH5KCBCYZM	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:36:11.983+00	\N	{"vendor": "pendant"}
prod_01KZ6CDKYQR48K72DFGE82BV0X	Ear Candy	ear-candy	\N	<p><meta charset="utf-8"><span id="docs-internal-guid-65cee0fa-7fff-7f53-ed7b-05ce0e27358d">candy without calories</span></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/2_07a38ece-9c85-48c7-9b83-4b978b137ec8.webp?v=1734460237	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:43:29.364+00	\N	{"vendor": "vembley"}
prod_01KZ6CDKYQZYC4BQ53JRC9CSD8	Drippin' Gold	drippin-gold	\N	<p><strong>Founder’s note :</strong><br>These dangly earrings are so simple at first glance—and then they move, and you’re like okay wait, that’s cutee. I love how they add just the right oomph without being too much. Honestly makes such a good gift for anyone who keeps things simple but stylish.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_8482.jpg?v=1734460059	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ769HJN6BMG6MZN38MW1QZT	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:44:58.725+00	\N	{"vendor": "Strawb"}
prod_01KZ6CDKYY82VSC9VRBD393XVG	Queen's Reign	queens-reign	\N	<div class="logo-gutter ng-tns-c1092752189-241 ng-star-inserted">\n<div class="resize-observable">\n<meta charset="utf-8"> <span id="docs-internal-guid-9994091a-7fff-469a-872e-824137c260e5">It’s a stack and looks so cool. so street!</span>\n</div>\n</div>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_cfd39683-8334-4767-820b-23da5cd38b22.jpg?v=1717246461	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 18:10:09.946+00	\N	\N
prod_01KZ6CDKYT8BWSMYXVRH3HD1JT	Mirchi	mirchi	\N	<p><strong>Founder’s note :</strong><br>I made this thinking of Bombay &amp; Vada Pav—and somehow, it turned into everyone’s fav piece. Mirchi is small, spicy, and makes you feel like you did something right with your outfit. Gifting this? Just know they’ll talk about it. PS: we were wiped out during Valentine’s, so yeah… people get it.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_5224.jpg?v=1760969116	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.944+00	\N	\N
prod_01KZ6CDKYVVCPP054QV0XAZGXF	Ocean Drop	ocean-drop	\N	<p><strong>Founder’s note :</strong><br>I mean, blue’s my fave, so I was already sold. The teardrop shimmer, the gold contrast, love it. I reach for it on days when I want to feel a little extra magic without trying too hard. Everyone who gets it ends up wearing it way more than they thought.<img src="https://em-content.zobj.net/source/apple/391/blue-heart_1f499.png" loading="lazy" alt="emoji-timeline" width="13" height="13"></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ocean_drop_blue_pendant.jpg?v=1754695786	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.481+00	2026-08-04 18:10:09.945+00	\N	\N
prod_01KZ6CDKYVAB6E3QJV4YFT0RBW	My Heart	my-heart	\N	<p>Trust me, this one is my fav. No description, just buy it. If you don't like it, full refund. It's that close to my heart</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_7675.jpg?v=1732801204	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.945+00	\N	\N
prod_01KZ6CDKZ0H2CPWHX4YDE9MWCM	Thunderstruck	thunderstruck	\N	<p>This gold choker necklace features a bold lightning bolt design, a flash of brilliance that electrifies any look.  More than just a trendy necklace, it's a powerful reminder to own your confidence and conquer anything that comes your way. </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_b9b5a05a-0d4c-48d7-b213-413ca97f0d51.jpg?v=1717246550	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.487+00	2026-08-04 18:10:09.947+00	\N	\N
prod_01KZ6CDKYTAQ19H3S7SES4WHV4	Mermaid's Necklace	mermaids-necklace	\N	<p>Straight from Atlantic, a beachy necklace only for the mermaids. </p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2024-12-17-21h05m41s696-2.jpg?v=1734450890	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.945+00	\N	\N
prod_01KZ6Y4FTH912SHCT626EJW0XS	Queen's chain	queens-chain		<p><meta charset="utf-8"><span id="docs-internal-guid-f8cb433f-7fff-13ce-0f1f-35efd223e001">This </span><span>dainty necklace</span><span> features a single, polished </span><span>coin pendant</span><span> - a minimalist </span><span>locket necklace </span><span>perfect for everyday wear. Wear it as a</span><span> lucky charm</span><span>, as it brings a touch of fortune to your everyday life.</span></p>	f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 17:46:24.467+00	2026-08-04 18:10:09.948+00	\N	\N
prod_01KZ6CDKZ018SVF05RXG350H68	Caterpillar Ring	tennis-ring	\N	<p><strong>Founder’s note :</strong><br>Every time I wear this, I feel like I’ve got a trust fund. The shine is unreal, the gems are chef’s kiss, and the compliments? Non-stop. It’s adjustable, so it’s the easiest gift ever. Also...we've got matching tennis bracelets &lt;3</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_9119.jpg?v=1766521702	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 18:10:09.947+00	\N	\N
prod_01KZ6CDKYSHC0QM80WW9BRKDEN	Loop	loop	\N	<p><strong>Founder’s note :</strong><br>You’ve definitely seen this on your feed—and now it’s here. The perfect everyday stack. Two-in-one and super easy to style. Makes a fab gift for that friend who always wants to be in trend.</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1531.jpg?v=1744478357	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.48+00	2026-08-04 18:10:09.944+00	\N	\N
prod_01KZ6CDKYYR42B0PEP10Y3FT52	Sakura	sakura	\N	<p><strong>Founder’s note :</strong><br>A bracelet that looks like it was picked from a garden at golden hour. Designed by a Japanese artist and inspired by sakura blooms, it’s gentle, warm, and easy to wear. And since it’s resizable—it’s basically made for gifting. It’s the kind of piece I’d gift to someone I really adore.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/vlcsnap-2025-02-19-19h39m28s429.jpg?v=1739977337	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.482+00	2026-08-04 18:10:09.946+00	\N	\N
prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	VeChain	ve-chain	\N	<p><strong>Founder’s note :</strong><br>If I had a rupee for every time someone asked for this necklace, I’d not need to write this. It’s that good. Perfect for gifting, perfect for keeping, and kind of a no-brainer if you want something that always gets compliments.<br></p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/ChatGPT_Image_Apr_21_2025_11_07_57_PM.png?v=1745260814	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.487+00	2026-08-04 18:10:09.947+00	\N	\N
prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	Emerald Drops	emerald-drops	\N	<p><strong>Founder’s note :</strong><br>Everyone who’s got it basically lives in it now. It’s simple but not boring, the green stones give it that perfect little twist. It’s our customer’s go-to gift pick—looks great solo, even better stacked!</p>	f	published	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/IMG_1539.jpg?v=1742232482	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	\N	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:38:55.873+00	\N	{"vendor": "Outrun"}
prod_01KZ6CDKYQA9WY630Q6ZQAHXAY	Teardrop Necklace	emerald-choker	\N	<p>Embrace understated elegance with the Teardrop Necklace. This necklace embodies minimalism at its finest, featuring a delicate chain that drapes effortlessly around your neck. But, the true star of the show is the faceted gemstones that catch the light with subtle brilliance, adding a touch of luxury to your everyday look.</p>\n<p>Whether you prefer emeralds, a touch of green, or a classic gemstone, this necklace offers timeless sophistication that complements any outfit.</p>\n<p>This is more than just an emerald necklace or a gold choker necklace, it's a versatile piece that elevates your style.</p>\n<p><span style="font-weight: 400;"><br></span></p>	f	draft	https://cdn.shopify.com/s/files/1/0572/3137/6471/files/1_51c547ef-eeb5-40bb-a6d9-015ebab3f4b1.jpg?v=1711834066	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	ptyp_01KZ76A05F5A855JCH5KCBCYZM	t	\N	2026-08-04 12:36:49.478+00	2026-08-05 12:41:42.107+00	\N	{"vendor": "tarohi"}
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata, external_id) FROM stdin;
pcat_01KYYM12BYH6ZR4K2PPRDGW1ZH	Sweatshirts		sweatshirts	pcat_01KYYM12BYH6ZR4K2PPRDGW1ZH	t	f	1	\N	2026-08-01 12:15:51.177+00	2026-08-04 19:47:19.891+00	2026-08-04 19:47:19.889+00	\N	\N
pcat_01KYYM12C2NCM0EDHYBNM3WYGE	Pants		pants	pcat_01KYYM12C2NCM0EDHYBNM3WYGE	t	f	1	\N	2026-08-01 12:15:51.178+00	2026-08-04 19:47:24.326+00	2026-08-04 19:47:24.325+00	\N	\N
pcat_01KYYM12C6VBB43MDYDD6N9H56	Merch		merch	pcat_01KYYM12C6VBB43MDYDD6N9H56	t	f	1	\N	2026-08-01 12:15:51.178+00	2026-08-04 19:47:27.908+00	2026-08-04 19:47:27.907+00	\N	\N
pcat_01KZ755KWD4669SHTN4KMVPEHM	Body Jewelry		body-jewelry	pcat_01KZ755KWD4669SHTN4KMVPEHM	t	f	0	\N	2026-08-04 19:49:21.423+00	2026-08-04 19:49:21.423+00	\N	\N	\N
pcat_01KYYM12BW9VBQHKF1HTGNNM4D	Bracelets		Bracelets	pcat_01KYYM12BW9VBQHKF1HTGNNM4D	t	f	2	\N	2026-08-01 12:15:51.176+00	2026-08-04 19:49:21.423+00	\N	\N	\N
pcat_01KZ7532VBZJK51N0Z5B898T51	Anklets		Anklets	pcat_01KZ7532VBZJK51N0Z5B898T51	t	f	1	\N	2026-08-04 19:47:58.446+00	2026-08-04 19:49:21.423+00	\N	\N	\N
pcat_01KZ756GK037VGRGNK2DGQY4AE	Earrings		Earrings	pcat_01KZ756GK037VGRGNK2DGQY4AE	t	f	3	\N	2026-08-04 19:49:50.817+00	2026-08-04 19:49:50.817+00	\N	\N	\N
pcat_01KZ7578X5GM1N6SMYRK9TTEWC	Jewelry Sets		jewelry-sets	pcat_01KZ7578X5GM1N6SMYRK9TTEWC	t	f	4	\N	2026-08-04 19:50:15.718+00	2026-08-04 19:50:15.718+00	\N	\N	\N
pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ	Necklaces		Necklaces	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ	t	f	5	\N	2026-08-04 19:50:51.194+00	2026-08-04 19:50:51.194+00	\N	\N	\N
pcat_01KZ75952DXDVCZ6WQRZG9FPAK	Watches		Watches	pcat_01KZ75952DXDVCZ6WQRZG9FPAK	t	f	6	\N	2026-08-04 19:51:17.326+00	2026-08-04 19:51:17.326+00	\N	\N	\N
pcat_01KZ759Q0Y4ZWW57QS3EQT1KWX	Smart Watches		smart-watches	pcat_01KZ759Q0Y4ZWW57QS3EQT1KWX	t	f	7	\N	2026-08-04 19:51:35.711+00	2026-08-04 19:51:35.711+00	\N	\N	\N
pcat_01KZ75ADNB7E97SGYBGGFNC0F8	Dental Grills		dental-grills	pcat_01KZ75ADNB7E97SGYBGGFNC0F8	t	f	8	\N	2026-08-04 19:51:58.891+00	2026-08-04 19:51:58.891+00	\N	\N	\N
pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q	Homepage		homepage	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q	t	f	9	\N	2026-08-05 10:50:02.964+00	2026-08-05 10:50:02.964+00	\N	\N	\N
pcat_01KZ8RRVWPJKQMN3X3JYEW4F15	New Launches		newlaunches	pcat_01KZ8RRVWPJKQMN3X3JYEW4F15	t	f	10	\N	2026-08-05 10:51:09.593+00	2026-08-05 10:51:42.828+00	\N	\N	\N
pcat_01KZ8RV3DV856FHN3N7GG0Y2A9	Best Sellers		best-sellers	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9	t	f	11	\N	2026-08-05 10:52:22.845+00	2026-08-05 10:52:22.845+00	\N	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01KYYM12HNB3B06MTFGRDQ6HER	pcat_01KYYM12BW9VBQHKF1HTGNNM4D
prod_01KYYM12HPNF1205QN0N30DVZ7	pcat_01KYYM12BYH6ZR4K2PPRDGW1ZH
prod_01KYYM12HPFK3M2KARA0JVMBZV	pcat_01KYYM12C2NCM0EDHYBNM3WYGE
prod_01KYYM12HPCG0WKM9PV50YN7NH	pcat_01KYYM12C6VBB43MDYDD6N9H56
prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	pcat_01KYYM12BW9VBQHKF1HTGNNM4D
prod_01KZ6CDKYNFYQ8KEWXD75JHSMR	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYN61S7DVMW2DEQXG56	pcat_01KYYM12BW9VBQHKF1HTGNNM4D
prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYN61S7DVMW2DEQXG56	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYN61S7DVMW2DEQXG56	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYNR4MMKW0P0TKPM2EY	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ
prod_01KZ6CDKYNR4MMKW0P0TKPM2EY	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYNSVSVB52D31W5Z60T	pcat_01KYYM12BW9VBQHKF1HTGNNM4D
prod_01KZ6CDKYNSVSVB52D31W5Z60T	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYP0NXWRGS0S9F7YK07	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYP0NXWRGS0S9F7YK07	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYP0NXWRGS0S9F7YK07	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	pcat_01KZ8RRVWPJKQMN3X3JYEW4F15
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYPDQG0QDKT37MDDPA3	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYPDQG0QDKT37MDDPA3	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYPDQG0QDKT37MDDPA3	pcat_01KYYM12BW9VBQHKF1HTGNNM4D
prod_01KZ6CDKYPM773V64EKZDC8TZ3	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYPM773V64EKZDC8TZ3	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYPM773V64EKZDC8TZ3	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYPP489B1SJAPJ484NC	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYPP489B1SJAPJ484NC	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYPP489B1SJAPJ484NC	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ
prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ
prod_01KZ6CDKYQA9WY630Q6ZQAHXAY	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYQA9WY630Q6ZQAHXAY	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ
prod_01KZ6CDKYQR48K72DFGE82BV0X	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYQR48K72DFGE82BV0X	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYQZYC4BQ53JRC9CSD8	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	pcat_01KZ8RRVWPJKQMN3X3JYEW4F15
prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ
prod_01KZ6CDKYR6NPKX84Y57F84V1Q	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYR6NPKX84Y57F84V1Q	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYR72K3JFDD9WRHXFMP	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYR72K3JFDD9WRHXFMP	pcat_01KZ758BHS3VPKAB8QV2Y28ZDZ
prod_01KZ6CDKYRZ215S2ACPC8ER0DH	pcat_01KZ8RV3DV856FHN3N7GG0Y2A9
prod_01KZ6CDKYRZ215S2ACPC8ER0DH	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYRZ215S2ACPC8ER0DH	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYS41JESCZCY4BCM9FM	pcat_01KZ8RPTTG14K1HVHYSYW3JA5Q
prod_01KZ6CDKYS41JESCZCY4BCM9FM	pcat_01KZ756GK037VGRGNK2DGQY4AE
prod_01KZ6CDKYSCZ5V05NQEKZQHW9B	pcat_01KZ7578X5GM1N6SMYRK9TTEWC
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at, external_id) FROM stdin;
pcol_01KZ6X1M9HMWB6S11B2WRPGKX2	Necklace	necklace	{"description": "<p></p>"}	2026-08-04 17:27:22.156296+00	2026-08-04 18:12:58.083+00	2026-08-04 18:12:58.082+00	\N
pcol_01KZ6V8K659XWQB5M99ZZ13ZS8	New Launches	new-launches	{"description": "<p><strong>Founder’s note :</strong><br>Same DNA as <a href=\\"https://strawb.in/products/swirly\\" target=\\"_blank\\" rel=\\"noopener\\">Swirly</a>, but with a lil extra twist—literally. This earring is all kinds of abstract and fun. Makes a great gift for someone who loves the unexpected. Feels cool, looks cooler. I wear this all the time. It looks like a sculpture ykwim. Compliments guaranteed.</p>"}	2026-08-04 16:56:13.276+00	2026-08-04 18:13:11.254+00	2026-08-04 18:13:11.254+00	\N
pcol_01KZ6VPE6GGMF9YNX7GHD33JZV	Best Sellers	best-sellers	{"description": "<p>Best selling earrings, necklaces, rings and bracelets. It contains a mix of everything which will suit all your fits. Each one of them make a great gift for her/them or yourself ;)</p>"}	2026-08-04 17:03:46.894814+00	2026-08-05 22:41:53.881+00	2026-08-05 22:41:53.878+00	\N
pcol_01KZ6Y7VVMJZ1X8R9TV4W426QP	Best Sellers	best-sellers	\N	2026-08-04 17:48:15.138215+00	2026-08-05 22:42:11.482+00	\N	\N
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_option (id, title, metadata, created_at, updated_at, deleted_at, is_exclusive) FROM stdin;
opt_01KZ6BYQZKJ0FN6WQ04WERKKJA	Color	\N	2026-08-04 12:28:42.147+00	2026-08-04 12:28:42.147+00	\N	t
opt_01KZ6BYQZKJJWSARSWVA3F25ES	Title	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZKQQ4Q9PWVNFQBXV68	Color	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZMTBEG6CDQ2CTVZYGC	Make it a stack?	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZMW7EJZFNCA8C2MYJP	Color	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZM2VKJ0Q99BZ0WBC1V	Title	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZMDGCADWJNMWX256W2	Material	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZMQA7FKGKZAEG1B6MY	Color	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZM2QEJEA439KTG61AM	Title	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZNTG6YES876CWPQ244	Title	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZNJH4WQDEX6W90YVHX	Title	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZNV8KF2X42PT430E2G	Title	\N	2026-08-04 12:28:42.148+00	2026-08-04 12:28:42.148+00	\N	t
opt_01KZ6BYQZN028GATXQEDDY6VX4	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZPMZEM996SCBT6D0AR	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZP8FSENYXF3EDKCREZ	Color	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZPBD9WZ5G4YB48ZFPJ	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZPTBMTCN74F72HQTS0	Color	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZP8CCFXSYR88086VB4	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZQJ0C62P05P85K6SFT	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZQPSE05H6Y7D2Y19WA	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZQWHQYYJEW1QH5FJM0	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZQCETM4EDEHTNXJ7VT	Chose your style	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZQMSWJC2B0QWWWXJ12	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZRRXXDET8KCTAHQQD9	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZR0V2YA1YPWZRZXTSV	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZS37Y9GC4CMCTV6M6C	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZST49C3AT2TWV67N3E	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZSK2ND2GBAJ7N37299	Title	\N	2026-08-04 12:28:42.149+00	2026-08-04 12:28:42.149+00	\N	t
opt_01KZ6BYQZSYS9MBD2DD2XCCS90	Title	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZS6JPP701CV29S590D	Title	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZTKE30JFTTY0GJE2H7	Color	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZTXSRB9YVN52VED0YP	Ring size	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZTF8TAT38MHKM53W3D	Title	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZTTRFV8QWJ3JXS4KE0	Title	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZTF0S3XQETEDYFF03B	Title	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZTX09QPVN9GDG9PQZE	Material	\N	2026-08-04 12:28:42.15+00	2026-08-04 12:28:42.15+00	\N	t
opt_01KZ6BYQZVA2B1M8JRJDHZQSZN	Material	\N	2026-08-04 12:28:42.151+00	2026-08-04 12:28:42.151+00	\N	t
opt_01KZ6BYQZVDAD4QTECVRN0JBCN	Title	\N	2026-08-04 12:28:42.151+00	2026-08-04 12:28:42.151+00	\N	t
opt_01KZ6BYQZVYZFNPE4FZ1PWYZFX	Title	\N	2026-08-04 12:28:42.151+00	2026-08-04 12:28:42.151+00	\N	t
opt_01KZ6BYQZVD89Z93NY64QBN5FY	Title	\N	2026-08-04 12:28:42.152+00	2026-08-04 12:28:42.152+00	\N	t
opt_01KZ6BYQZWVGTH569724785VKV	Title	\N	2026-08-04 12:28:42.152+00	2026-08-04 12:28:42.152+00	\N	t
opt_01KZ6BYQZW0YVKD9DP7HHNJNJJ	Title	\N	2026-08-04 12:28:42.152+00	2026-08-04 12:28:42.152+00	\N	t
opt_01KZ6BYQZW153976S8PDCP8J3J	Select your ring(s)	\N	2026-08-04 12:28:42.152+00	2026-08-04 12:28:42.152+00	\N	t
opt_01KZ6BYQZW18Q27G5X0G8PVN9G	Title	\N	2026-08-04 12:28:42.152+00	2026-08-04 12:28:42.152+00	\N	t
opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	Color	\N	2026-08-04 12:28:42.153+00	2026-08-04 12:28:42.153+00	\N	t
opt_01KZ6BYQZWY6RQ9BNH7GGNEMN4	Title	\N	2026-08-04 12:28:42.153+00	2026-08-04 12:28:42.153+00	\N	t
opt_01KZ6BYQZXAKWFP3EDTVNEGRES	Color Options	\N	2026-08-04 12:28:42.153+00	2026-08-04 12:28:42.153+00	\N	t
opt_01KZ6BYQZXSWJHJB8ZGWH2KDTR	Necklace design	\N	2026-08-04 12:28:42.153+00	2026-08-04 12:28:42.153+00	\N	t
opt_01KZ6BYQZXCQ1G6F32BZAKXX7P	Title	\N	2026-08-04 12:28:42.153+00	2026-08-04 12:28:42.153+00	\N	t
opt_01KZ6BYQZXHJ2M39JQ9HQ8BT94	Title	\N	2026-08-04 12:28:42.153+00	2026-08-04 12:28:42.153+00	\N	t
opt_01KZ6BYQZX1CVXMJQVMJ88V6E3	Title	\N	2026-08-04 12:28:42.154+00	2026-08-04 12:28:42.154+00	\N	t
opt_01KZ6CDKZ1CND6KZT55WCK957Z	Color	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ1Q2FARYA8B54EMM2Y	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ2FZAKJQXW1QBYSNRX	Make it a stack?	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ2C9AQ6HSA2TX01MZ7	Color	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ3ZYKM8S5AEVDEXKJZ	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ3TS8N63R93RTFMP2J	Material	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ35PBTXFMR73WDHZCE	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ3DG1XE5JWJ43RS04V	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ4FPJSC5EHWVPQD7QY	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ5Z3XWXEYXZD00E910	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ5QN76WTX65FCSPNEH	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ5BGKEZ0M8D12F8YZ2	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ5A3TYEEQZ71A1BJZG	Color	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ6JRBFSJH5MMKJEEQE	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ6QGYD6RT5H7ABGDJF	Color	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ6KK1WM4VBSSXJ1FEJ	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ6NHFXVZ0DA0TFA9WD	Title	\N	2026-08-04 12:36:49.488+00	2026-08-04 12:36:49.488+00	\N	t
opt_01KZ6CDKZ6AE5KEHKW0QR5EBQ7	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ7ZD6GVTB2NMS35XRB	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ70X6Y4E9ZZ7JFRX84	Chose your style	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ7H5S1PFDYHEXE0T5R	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ7S5KQSMJ31R724KM8	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ7K3A3V137NHT658HK	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ7KCPV3BPWQCG6E0X0	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ7W9FZTN4D9GM2A9RJ	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ8JEKB8G0S1C505CAR	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ8Y42JTJ1QZQ1ZE35H	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ8CD00756AX3KKPZ9P	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ8G43T4KVA30HS52AJ	Color	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ896CT2AA1930NSZS6	Ring size	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ8DFFK82CBBCYYJ0FS	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ9S7Y9P544GBVJWJ77	Title	\N	2026-08-04 12:36:49.489+00	2026-08-04 12:36:49.489+00	\N	t
opt_01KZ6CDKZ2MB4DN8X3JEMYQ1ER	Color	\N	2026-08-04 12:36:49.488+00	2026-08-04 22:56:15.508+00	2026-08-04 22:56:15.507+00	t
opt_01KZ6CDKZ3VDN2Q4VJZJY8KX5R	Color	\N	2026-08-04 12:36:49.488+00	2026-08-05 12:17:38.77+00	2026-08-05 12:17:38.768+00	t
opt_01KYYM12E5S6RCR0PE1ZDH1XGC	Color	\N	2026-08-01 12:15:51.239+00	2026-08-04 22:54:58.346+00	\N	f
opt_01KZ6CDKZ9K8VF4957SQN37VD4	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZ97M84FYADCJCSZACR	Material	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZ99T0ZN886DB48ZPB2	Material	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZ91S4NPYATAXDJZXV0	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZ9K44SMACSXSHXEZ5H	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZA8405237QRDHQ1ZMJ	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZA947AN30ZR986092Y	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZAP6G0F838DP0ZR8TA	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZAW5ENTDA3QFQYE5TF	Select your ring(s)	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZAVVRBE82XQ76HN8D2	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	Color	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZBJMSH64E7HFGMR5KQ	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZBZKZYNNYYFPGPN4YW	Color Options	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZB908Y8KEMCYBRPGPF	Necklace design	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZBTJ4RWFJB21TWN2FD	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZBQBRF2B6NNXTBDBWJ	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6CDKZB4DYT121EX504MQ35	Title	\N	2026-08-04 12:36:49.49+00	2026-08-04 12:36:49.49+00	\N	t
opt_01KZ6WJVEFP7J8RV7SQARBQRYC	Default option	\N	2026-08-04 17:19:17.97+00	2026-08-04 17:19:17.97+00	\N	t
opt_01KZ6Y4FTJK6KW53BKH8YZBW3C	Default option	\N	2026-08-04 17:46:24.467+00	2026-08-04 17:46:24.467+00	\N	t
opt_01KYYM12E37TPX938Z7BSMYF9N	Size	\N	2026-08-01 12:15:51.239+00	2026-08-04 19:56:02.137+00	2026-08-04 19:56:02.13+00	f
opt_01KZ75VSWQ4AA65DSHA6THQKW2	Jewelry material	\N	2026-08-04 20:01:28.472+00	2026-08-04 20:01:28.472+00	\N	f
opt_01KZ75WYDGWA3HE0D0V2Y20ABG	Age group	\N	2026-08-04 20:02:05.873+00	2026-08-04 20:02:05.873+00	\N	f
opt_01KZ760S5BKN7C9QH193B0KBDM	Jewelary type	\N	2026-08-04 20:04:11.565+00	2026-08-04 20:04:11.565+00	\N	f
opt_01KZ762MER3T0A5BXHGK1S033Z	Target gender	\N	2026-08-04 20:05:12.281+00	2026-08-04 20:05:12.281+00	\N	f
opt_01KZ764FN62A8JWXJ2YAJVSYVA	Metal purity	\N	2026-08-04 20:06:12.903+00	2026-08-04 20:06:12.903+00	\N	f
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at, rank) FROM stdin;
optval_01KZ6BYR6CMFRNX4J74AEGMNDJ	gold	opt_01KZ6BYQZKJ0FN6WQ04WERKKJA	\N	2026-08-04 12:28:42.213+00	2026-08-04 12:28:42.213+00	\N	\N
optval_01KZ6BYR6DX903RHVH9BF60DK2	silver	opt_01KZ6BYQZKJ0FN6WQ04WERKKJA	\N	2026-08-04 12:28:42.214+00	2026-08-04 12:28:42.214+00	\N	\N
optval_01KZ6BYR6DV5GTFPJMJ82QCYM9	Default Title	opt_01KZ6BYQZKJJWSARSWVA3F25ES	\N	2026-08-04 12:28:42.214+00	2026-08-04 12:28:42.214+00	\N	\N
optval_01KZ6BYR6ECXP4ETETQPB5GEGY	gold	opt_01KZ6BYQZKQQ4Q9PWVNFQBXV68	\N	2026-08-04 12:28:42.215+00	2026-08-04 12:28:42.215+00	\N	\N
optval_01KZ6BYR6ET4VDMJ4S58VVV1H0	1	opt_01KZ6BYQZMTBEG6CDQ2CTVZYGC	\N	2026-08-04 12:28:42.215+00	2026-08-04 12:28:42.215+00	\N	\N
optval_01KZ6BYR6FEQSH8KM8FCGM35E9	2	opt_01KZ6BYQZMTBEG6CDQ2CTVZYGC	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.216+00	\N	\N
optval_01KZ6BYR6F9BEXET616CXZDG62	3	opt_01KZ6BYQZMTBEG6CDQ2CTVZYGC	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.216+00	\N	\N
optval_01KZ6BYR6GKF6HCXGN0H32NSAA	4	opt_01KZ6BYQZMTBEG6CDQ2CTVZYGC	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.216+00	\N	\N
optval_01KZ6BYR6GH5CB209G8XK15SXW	Gold	opt_01KZ6BYQZMW7EJZFNCA8C2MYJP	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.216+00	\N	\N
optval_01KZ6BYR6HBHYMP58KBF79214W	Silver	opt_01KZ6BYQZMW7EJZFNCA8C2MYJP	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.216+00	\N	\N
optval_01KZ6BYR6HWSSKJ732YMS7Q9DT	Default Title	opt_01KZ6BYQZM2VKJ0Q99BZ0WBC1V	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.216+00	\N	\N
optval_01KZ6BYR6J7Y6QVVBW8T8MCBZ0	Gold	opt_01KZ6BYQZMDGCADWJNMWX256W2	\N	2026-08-04 12:28:42.216+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6JRZN8QKRQX4AGEZS7	Silver	opt_01KZ6BYQZMDGCADWJNMWX256W2	\N	2026-08-04 12:28:42.217+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6KA0EEDZKAMBAD4TV8	green	opt_01KZ6BYQZMQA7FKGKZAEG1B6MY	\N	2026-08-04 12:28:42.217+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6KHYJYCF26M83ZEPQP	black	opt_01KZ6BYQZMQA7FKGKZAEG1B6MY	\N	2026-08-04 12:28:42.217+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6K9FWQGV1TM3BWFSQZ	white	opt_01KZ6BYQZMQA7FKGKZAEG1B6MY	\N	2026-08-04 12:28:42.217+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6MZYAY55QVWTZV65VN	red	opt_01KZ6BYQZMQA7FKGKZAEG1B6MY	\N	2026-08-04 12:28:42.217+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6MMWM1KTK1VMQT7SE9	Default Title	opt_01KZ6BYQZM2QEJEA439KTG61AM	\N	2026-08-04 12:28:42.217+00	2026-08-04 12:28:42.217+00	\N	\N
optval_01KZ6BYR6NBF741NJ96M4CNFRN	Default Title	opt_01KZ6BYQZNTG6YES876CWPQ244	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6PBYS4R80TNJ6T1BQA	Default Title	opt_01KZ6BYQZNJH4WQDEX6W90YVHX	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6QCJQ6JBXDEWM9A9S5	Default Title	opt_01KZ6BYQZNV8KF2X42PT430E2G	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6QYJ5TWF816C1NZJAS	Default Title	opt_01KZ6BYQZN028GATXQEDDY6VX4	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6STCDN5028HZGBKEFX	Default Title	opt_01KZ6BYQZPMZEM996SCBT6D0AR	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6S9XCE2VMGG1VZS0TZ	silver	opt_01KZ6BYQZP8FSENYXF3EDKCREZ	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6TXTHWJNNB8EC77D7Z	gold	opt_01KZ6BYQZP8FSENYXF3EDKCREZ	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6VCNAS47T8SVCFK5SK	Default Title	opt_01KZ6BYQZPBD9WZ5G4YB48ZFPJ	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6VER3DAF9B7AM4CJGA	silver	opt_01KZ6BYQZPTBMTCN74F72HQTS0	\N	2026-08-04 12:28:42.218+00	2026-08-04 12:28:42.218+00	\N	\N
optval_01KZ6BYR6VBWCE2WP78QY4860W	gold	opt_01KZ6BYQZPTBMTCN74F72HQTS0	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR6WTJEY7V80SSPHQDGB	Default Title	opt_01KZ6BYQZP8CCFXSYR88086VB4	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR6X4QS5W93PR8C7G5M2	Default Title	opt_01KZ6BYQZQJ0C62P05P85K6SFT	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR6X8XVYTF05J8S8FDRP	Default Title	opt_01KZ6BYQZQPSE05H6Y7D2Y19WA	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR6Y59ZWX598B9BMQGKC	Default Title	opt_01KZ6BYQZQWHQYYJEW1QH5FJM0	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR6Z2E1ZX2GW7A4XX858	Necklace	opt_01KZ6BYQZQCETM4EDEHTNXJ7VT	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR6ZPH889JK27VVY10AC	Earrings	opt_01KZ6BYQZQCETM4EDEHTNXJ7VT	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR70ZSZPBFC0423PDPW8	Necklace + Earrings	opt_01KZ6BYQZQCETM4EDEHTNXJ7VT	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR70GAN9MD17M46MP6GP	Extra Rope	opt_01KZ6BYQZQCETM4EDEHTNXJ7VT	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR70D9Y97CW8BQSNYP2Q	Default Title	opt_01KZ6BYQZQMSWJC2B0QWWWXJ12	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR71NK0YVB7S9E5XB1ZZ	Default Title	opt_01KZ6BYQZRRXXDET8KCTAHQQD9	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR727JSNAJA54YX647XK	Default Title	opt_01KZ6BYQZR0V2YA1YPWZRZXTSV	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR73HF285Y5YZJCAWSR0	Default Title	opt_01KZ6BYQZS37Y9GC4CMCTV6M6C	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR73ZY8Z4XP0JG7MSEBK	Default Title	opt_01KZ6BYQZST49C3AT2TWV67N3E	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR74KVVCAHBRAZ4P7ZPP	Default Title	opt_01KZ6BYQZSK2ND2GBAJ7N37299	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR75JAK6QHM178YX3WN9	Default Title	opt_01KZ6BYQZSYS9MBD2DD2XCCS90	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR76AQATFXMSV71PBVTQ	Default Title	opt_01KZ6BYQZS6JPP701CV29S590D	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR76SCKF23JAA8ZWF40D	Both Rings	opt_01KZ6BYQZTKE30JFTTY0GJE2H7	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR77MWN2X6SC26TJ38YW	Only Back Ring	opt_01KZ6BYQZTKE30JFTTY0GJE2H7	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR78AA3DQHKE1J5ZRR4B	6	opt_01KZ6BYQZTXSRB9YVN52VED0YP	\N	2026-08-04 12:28:42.219+00	2026-08-04 12:28:42.219+00	\N	\N
optval_01KZ6BYR793J8S30DYE4BP17C7	Default Title	opt_01KZ6BYQZTF8TAT38MHKM53W3D	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7BEEK94Y2HJ5J5MZQG	Default Title	opt_01KZ6BYQZTTRFV8QWJ3JXS4KE0	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7CSE32ZGCVKQV84QSK	Default Title	opt_01KZ6BYQZTF0S3XQETEDYFF03B	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7DHRRPR7GDBZBG0BJ9	Rose Gold	opt_01KZ6BYQZTX09QPVN9GDG9PQZE	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7E61J3QF66R9SN22K1	Gold	opt_01KZ6BYQZTX09QPVN9GDG9PQZE	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7FEVN5CP6EPQ3H8CQR	Rose Gold	opt_01KZ6BYQZVA2B1M8JRJDHZQSZN	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7F7RTENGM1QVDV79NN	Gold	opt_01KZ6BYQZVA2B1M8JRJDHZQSZN	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7GBGJWQFP4RSGJHXJK	Default Title	opt_01KZ6BYQZVDAD4QTECVRN0JBCN	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7HWKD2XRAYH4N4TRY1	Default Title	opt_01KZ6BYQZVYZFNPE4FZ1PWYZFX	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7JJJHQA42EZVE3X5M1	Default Title	opt_01KZ6BYQZVD89Z93NY64QBN5FY	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7K4HFS28KN22PZ291T	Default Title	opt_01KZ6BYQZWVGTH569724785VKV	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7M36G5THD47NS5K80G	Default Title	opt_01KZ6BYQZW0YVKD9DP7HHNJNJJ	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7NTTAJRMQ3329FVPJY	Both rings	opt_01KZ6BYQZW153976S8PDCP8J3J	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7PA926VZXE49N1VDZ8	Male ring	opt_01KZ6BYQZW153976S8PDCP8J3J	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KYYM12E4GF1KEEG6W45YHNTG	Black	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-01 12:15:51.241+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KYYM12E5GP466XZ56SDNBEHC	White	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-01 12:15:51.241+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ6BYR7PM0TFYPHF5X5RB53A	Female ring	opt_01KZ6BYQZW153976S8PDCP8J3J	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7QXGK3J5VXNS4SZMTW	Default Title	opt_01KZ6BYQZW18Q27G5X0G8PVN9G	\N	2026-08-04 12:28:42.22+00	2026-08-04 12:28:42.22+00	\N	\N
optval_01KZ6BYR7RHR0ASC1FTHYT2F2V	blue	opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7S6MYE9HEEY6PX4W5H	red	opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7SAHM8JWJBTKQXT2R5	black	opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7THJ15BRPB74XTWRCG	green	opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7VBX8SNHGX4CY0AF10	white	opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7VMVAVAVKPT9PVKPEE	purple	opt_01KZ6BYQZWVJJ9Y0JQER5CNK9B	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7WV148S6DK2C36XF8E	Default Title	opt_01KZ6BYQZWY6RQ9BNH7GGNEMN4	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7WR343K3STET93J6K9	green	opt_01KZ6BYQZXAKWFP3EDTVNEGRES	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7XXGP9GN2RSJ2KQEYC	white	opt_01KZ6BYQZXAKWFP3EDTVNEGRES	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7XXTHV4K8VPZ4QEQSH	black	opt_01KZ6BYQZXAKWFP3EDTVNEGRES	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7YT457PXACBXNTYQHA	chain	opt_01KZ6BYQZXSWJHJB8ZGWH2KDTR	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7ZHZ8CF8SW1AE973XA	pendant	opt_01KZ6BYQZXSWJHJB8ZGWH2KDTR	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR7ZT0K3GEGBVA4YFC5K	Default Title	opt_01KZ6BYQZXCQ1G6F32BZAKXX7P	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR80R53S010JKJRZE4HZ	Default Title	opt_01KZ6BYQZXHJ2M39JQ9HQ8BT94	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6BYR81X07FYYASN13S35EG	Default Title	opt_01KZ6BYQZX1CVXMJQVMJ88V6E3	\N	2026-08-04 12:28:42.226+00	2026-08-04 12:28:42.226+00	\N	\N
optval_01KZ6CDM3W28KJ5CB2T0Q3BCKW	gold	opt_01KZ6CDKZ1CND6KZT55WCK957Z	\N	2026-08-04 12:36:49.513+00	2026-08-04 12:36:49.513+00	\N	\N
optval_01KZ6CDM3WA5C0ZZVYV28RPJEA	silver	opt_01KZ6CDKZ1CND6KZT55WCK957Z	\N	2026-08-04 12:36:49.513+00	2026-08-04 12:36:49.513+00	\N	\N
optval_01KZ6CDM3YMXP8T2A8SZ31TPDK	Default Title	opt_01KZ6CDKZ1Q2FARYA8B54EMM2Y	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM42D7N5AVJ6BJAAKERC	1	opt_01KZ6CDKZ2FZAKJQXW1QBYSNRX	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM43ASG18CPQTFTH3Q5N	2	opt_01KZ6CDKZ2FZAKJQXW1QBYSNRX	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM43J6E75PPM9T0EG699	3	opt_01KZ6CDKZ2FZAKJQXW1QBYSNRX	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM44GRFAT1NQ41WSA4BJ	4	opt_01KZ6CDKZ2FZAKJQXW1QBYSNRX	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM45DKVND48S0VJFCD4C	Gold	opt_01KZ6CDKZ2C9AQ6HSA2TX01MZ7	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM459HTNZH620ZMQ9VZM	Silver	opt_01KZ6CDKZ2C9AQ6HSA2TX01MZ7	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM46H3SJ8EXB2TM37Y1Z	Default Title	opt_01KZ6CDKZ3ZYKM8S5AEVDEXKJZ	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM47YHXC0Y2KCWDW9RE8	Gold	opt_01KZ6CDKZ3TS8N63R93RTFMP2J	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM4806NTDY0K716PT6JC	Silver	opt_01KZ6CDKZ3TS8N63R93RTFMP2J	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM4CH9DQDJ36KV9DGPZ0	Default Title	opt_01KZ6CDKZ35PBTXFMR73WDHZCE	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM4D9BR267Y0S53NANB1	Default Title	opt_01KZ6CDKZ3DG1XE5JWJ43RS04V	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM4ESR6SQC81NSQMFSDV	Default Title	opt_01KZ6CDKZ4FPJSC5EHWVPQD7QY	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM4F7JCPS0WXYR7ZQNHW	Default Title	opt_01KZ6CDKZ5Z3XWXEYXZD00E910	\N	2026-08-04 12:36:49.514+00	2026-08-04 12:36:49.514+00	\N	\N
optval_01KZ6CDM4GQ7C3FSST8AGX7EMN	Default Title	opt_01KZ6CDKZ5QN76WTX65FCSPNEH	\N	2026-08-04 12:36:49.515+00	2026-08-04 12:36:49.515+00	\N	\N
optval_01KZ6CDM4HT9PXV9Y61ST3WXN2	Default Title	opt_01KZ6CDKZ5BGKEZ0M8D12F8YZ2	\N	2026-08-04 12:36:49.515+00	2026-08-04 12:36:49.515+00	\N	\N
optval_01KZ6CDM4H3FF7B0EK7VC9RED1	silver	opt_01KZ6CDKZ5A3TYEEQZ71A1BJZG	\N	2026-08-04 12:36:49.515+00	2026-08-04 12:36:49.515+00	\N	\N
optval_01KZ6CDM4J2GXRC50795KEHCTY	gold	opt_01KZ6CDKZ5A3TYEEQZ71A1BJZG	\N	2026-08-04 12:36:49.515+00	2026-08-04 12:36:49.515+00	\N	\N
optval_01KZ6CDM4J0H92EG4BSNWSYCZJ	Default Title	opt_01KZ6CDKZ6JRBFSJH5MMKJEEQE	\N	2026-08-04 12:36:49.515+00	2026-08-04 12:36:49.515+00	\N	\N
optval_01KZ6CDM4KE4PYQ1VGVGXCWW3R	silver	opt_01KZ6CDKZ6QGYD6RT5H7ABGDJF	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4KBMEW60CV3B53DZ4T	gold	opt_01KZ6CDKZ6QGYD6RT5H7ABGDJF	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4MDTND9CJS3A4ARX7M	Default Title	opt_01KZ6CDKZ6KK1WM4VBSSXJ1FEJ	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4NSE2R3T1GKK930K67	Default Title	opt_01KZ6CDKZ6NHFXVZ0DA0TFA9WD	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4N0W6KD19HYCJK05ZH	Default Title	opt_01KZ6CDKZ6AE5KEHKW0QR5EBQ7	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4PNS7JB9J5AFGW8HT3	Default Title	opt_01KZ6CDKZ7ZD6GVTB2NMS35XRB	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4PWJXTJ8XSE8X3329H	Necklace	opt_01KZ6CDKZ70X6Y4E9ZZ7JFRX84	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4QJ8Q6AQ43FAV5MV5Q	Earrings	opt_01KZ6CDKZ70X6Y4E9ZZ7JFRX84	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4RRX2F5CDDC7BMF2KA	Necklace + Earrings	opt_01KZ6CDKZ70X6Y4E9ZZ7JFRX84	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4S8Y24SK7KAHGHE90B	Extra Rope	opt_01KZ6CDKZ70X6Y4E9ZZ7JFRX84	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4T72AGF4W020M8R65X	Default Title	opt_01KZ6CDKZ7H5S1PFDYHEXE0T5R	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4VCTKCSP46YYJ99ZAQ	Default Title	opt_01KZ6CDKZ7S5KQSMJ31R724KM8	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4WX0JF3DHJ9MNC6MVD	Default Title	opt_01KZ6CDKZ7K3A3V137NHT658HK	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4XZ043QC52ZSTC8PQJ	Default Title	opt_01KZ6CDKZ7KCPV3BPWQCG6E0X0	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4X1G0SDBNBW728YVP6	Default Title	opt_01KZ6CDKZ7W9FZTN4D9GM2A9RJ	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4YFDTPR41VK295CWW3	Default Title	opt_01KZ6CDKZ8JEKB8G0S1C505CAR	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM4Z5TCNE79VCX1T4VC1	Default Title	opt_01KZ6CDKZ8Y42JTJ1QZQ1ZE35H	\N	2026-08-04 12:36:49.516+00	2026-08-04 12:36:49.516+00	\N	\N
optval_01KZ6CDM500W1GD1H173X7WT5H	Default Title	opt_01KZ6CDKZ8CD00756AX3KKPZ9P	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM51ZJ3ZMR8CSKTRG04C	Both Rings	opt_01KZ6CDKZ8G43T4KVA30HS52AJ	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM529NBZS3KY4G2CFGAG	Only Back Ring	opt_01KZ6CDKZ8G43T4KVA30HS52AJ	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM539S56WJKSMMZQZ8QG	6	opt_01KZ6CDKZ896CT2AA1930NSZS6	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM54EGVN6P7KGG65NY3M	Default Title	opt_01KZ6CDKZ8DFFK82CBBCYYJ0FS	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM555ZW57TMGB35SKW6Z	Default Title	opt_01KZ6CDKZ9S7Y9P544GBVJWJ77	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM55D828K3FT5XJ6VJW5	Default Title	opt_01KZ6CDKZ9K8VF4957SQN37VD4	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM4A4SNJ4G989694M922	green	opt_01KZ6CDKZ3VDN2Q4VJZJY8KX5R	\N	2026-08-04 12:36:49.514+00	2026-08-05 12:17:38.81+00	2026-08-05 12:17:38.768+00	\N
optval_01KZ6CDM58F1BTYF0SFZ5469KX	Rose Gold	opt_01KZ6CDKZ97M84FYADCJCSZACR	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM592MTFBTXW1R2E5M4Y	Gold	opt_01KZ6CDKZ97M84FYADCJCSZACR	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM594XE5XJ237T3HGGRY	Rose Gold	opt_01KZ6CDKZ99T0ZN886DB48ZPB2	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5AR7G5RXPW84G3BJN7	Gold	opt_01KZ6CDKZ99T0ZN886DB48ZPB2	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5B14HDBG0V0P3XF2FD	Default Title	opt_01KZ6CDKZ91S4NPYATAXDJZXV0	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5CSR6K28005PWYFDJ5	Default Title	opt_01KZ6CDKZ9K44SMACSXSHXEZ5H	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5DC2FCCVF2N8BZTFTN	Default Title	opt_01KZ6CDKZA8405237QRDHQ1ZMJ	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5EMWZ98YMGCYZF6X89	Default Title	opt_01KZ6CDKZA947AN30ZR986092Y	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5FGP487868D51CQ58Q	Default Title	opt_01KZ6CDKZAP6G0F838DP0ZR8TA	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5GBXK2BKA9DPQBS5S7	Both rings	opt_01KZ6CDKZAW5ENTDA3QFQYE5TF	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5GV1YHV6RA166SABS9	Male ring	opt_01KZ6CDKZAW5ENTDA3QFQYE5TF	\N	2026-08-04 12:36:49.517+00	2026-08-04 12:36:49.517+00	\N	\N
optval_01KZ6CDM5GA4D497QXKTV8E4D1	Female ring	opt_01KZ6CDKZAW5ENTDA3QFQYE5TF	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5H2JKWTG9SGK6SFX4W	Default Title	opt_01KZ6CDKZAVVRBE82XQ76HN8D2	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5JCKH1XKEYG8MPC4M3	blue	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5JJ7HV38ER0YNKAAC8	red	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5KJ6EEB6C8WAAT44VW	black	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5KGP3AD6HP38120VQR	green	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5MKSNY67SWV0N6JS8F	white	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5MWVCD58SSWJ47N15Q	purple	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5NBC5861V8TCZ325S2	Default Title	opt_01KZ6CDKZBJMSH64E7HFGMR5KQ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5P208EKYEDECEKWEV4	green	opt_01KZ6CDKZBZKZYNNYYFPGPN4YW	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5Q8QYJ024CJ6P86GYF	white	opt_01KZ6CDKZBZKZYNNYYFPGPN4YW	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5Q21JGJ33QR2MS6SWA	black	opt_01KZ6CDKZBZKZYNNYYFPGPN4YW	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5RXG46W504GMPXN4HZ	chain	opt_01KZ6CDKZB908Y8KEMCYBRPGPF	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5SW5W8GN7NRJCYPT1H	pendant	opt_01KZ6CDKZB908Y8KEMCYBRPGPF	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5SSGKX05JEEZBX67DZ	Default Title	opt_01KZ6CDKZBTJ4RWFJB21TWN2FD	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5VC3PZMKC1RA13G4Y4	Default Title	opt_01KZ6CDKZBQBRF2B6NNXTBDBWJ	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6CDM5WCS72Q798ZPN1EQWD	Default Title	opt_01KZ6CDKZB4DYT121EX504MQ35	\N	2026-08-04 12:36:49.518+00	2026-08-04 12:36:49.518+00	\N	\N
optval_01KZ6WJVEHC52BAJJ7FS9VD4V6	Default option value	opt_01KZ6WJVEFP7J8RV7SQARBQRYC	\N	2026-08-04 17:19:17.97+00	2026-08-04 17:19:17.97+00	\N	\N
optval_01KZ6Y4FTKAHXAKPTZSE9YWYBT	Default option value	opt_01KZ6Y4FTJK6KW53BKH8YZBW3C	\N	2026-08-04 17:46:24.467+00	2026-08-04 17:46:24.467+00	\N	\N
optval_01KYYM12E0DHAHVYGXWQ57V8JX	S	opt_01KYYM12E37TPX938Z7BSMYF9N	\N	2026-08-01 12:15:51.24+00	2026-08-04 19:56:02.194+00	2026-08-04 19:56:02.13+00	\N
optval_01KYYM12E1W92RPVQ879TJWH0G	M	opt_01KYYM12E37TPX938Z7BSMYF9N	\N	2026-08-01 12:15:51.24+00	2026-08-04 19:56:02.194+00	2026-08-04 19:56:02.13+00	\N
optval_01KYYM12E1AWWQJ28K70F972FQ	L	opt_01KYYM12E37TPX938Z7BSMYF9N	\N	2026-08-01 12:15:51.24+00	2026-08-04 19:56:02.195+00	2026-08-04 19:56:02.13+00	\N
optval_01KYYM12E2MGPF8547CKSXC4NE	XL	opt_01KYYM12E37TPX938Z7BSMYF9N	\N	2026-08-01 12:15:51.241+00	2026-08-04 19:56:02.195+00	2026-08-04 19:56:02.13+00	\N
optval_01KZ75VSWHHKX014PAWNF65YTA	Gold-plated	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	1
optval_01KZ75VSWJZDAW3JSW4MWG0DQG	Resin	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	2
optval_01KZ75VSWK36XR8VZEKCXQF0SF	Enamel	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	3
optval_01KZ75VSWM6A4K0VFH9P21SH6P	Acrylic	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	4
optval_01KZ75VSWMDCC5KJXFKEEETRVR	Metal	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	5
optval_01KZ75VSWN6J0895MVR1KXV15P	Titanium	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	6
optval_01KZ75VSWNQ29MX56VP7CZAPE7	Gold	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	7
optval_01KZ75VSWPYC0BAN61W9QH16QY	Bamboo	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	8
optval_01KZ75VSWPB4NMH9CDE3TQMT9F	Stainless steel	opt_01KZ75VSWQ4AA65DSHA6THQKW2	\N	2026-08-04 20:01:28.473+00	2026-08-04 20:01:28.473+00	\N	9
optval_01KZ75WYDFGSKD1JFQECXDZZBH	Teens	opt_01KZ75WYDGWA3HE0D0V2Y20ABG	\N	2026-08-04 20:02:05.873+00	2026-08-04 20:02:05.873+00	\N	1
optval_01KZ75WYDFAKW3H88JXV80HVM8	Adults	opt_01KZ75WYDGWA3HE0D0V2Y20ABG	\N	2026-08-04 20:02:05.873+00	2026-08-04 20:02:05.873+00	\N	2
optval_01KZ760S5AQN3Q13DZBDT917EV	Lmitation jewelary	opt_01KZ760S5BKN7C9QH193B0KBDM	\N	2026-08-04 20:04:11.565+00	2026-08-04 20:04:11.565+00	\N	1
optval_01KZ760S5ANSFFFZZ5G7FE5S14	Fine jewelary	opt_01KZ760S5BKN7C9QH193B0KBDM	\N	2026-08-04 20:04:11.565+00	2026-08-04 20:04:11.565+00	\N	2
optval_01KZ762MEP29R73F41FF023TFV	Male	opt_01KZ762MER3T0A5BXHGK1S033Z	\N	2026-08-04 20:05:12.282+00	2026-08-04 20:05:12.282+00	\N	1
optval_01KZ762MEQGM6MV3429TQB8TG3	Female	opt_01KZ762MER3T0A5BXHGK1S033Z	\N	2026-08-04 20:05:12.282+00	2026-08-04 20:05:12.282+00	\N	2
optval_01KZ762MEQ4XTP9F0M2AJJMPS4	Unisex	opt_01KZ762MER3T0A5BXHGK1S033Z	\N	2026-08-04 20:05:12.282+00	2026-08-04 20:05:12.282+00	\N	3
optval_01KZ764FN2QK9045G80GYE4T5X	375	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	1
optval_01KZ764FN3MNKG8EVZQ8JH2HXF	585	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	2
optval_01KZ764FN3GZ2Q6JSFM5FC9R61	750	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	3
optval_01KZ764FN4R2WCKTEG8P9226YJ	900	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	4
optval_01KZ764FN52XTFDS9HYNACZVYQ	925	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	5
optval_01KZ764FN5ACZV14ZD0AWR30Y5	950	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	6
optval_01KZ764FN64MENYCWQYVRHF7H4	999	opt_01KZ764FN62A8JWXJ2YAJVSYVA	\N	2026-08-04 20:06:12.904+00	2026-08-04 20:06:12.904+00	\N	7
optval_01KZ75Q2FQQ2XX0TPCDD4FMWQF	blue	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FR8P8RS40BP8CD528M	brown	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FSFKVX3NZ33F2QEMXE	silver	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FTMNJZZ0ZBMM6S235V	rose gold	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FV2AJE01X0YEZCHZXJ	purple	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FVGEQYW0B6QDVEJTE6	red	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FWX3TTSHW91BYT2X8P	green	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FXPAGBH5FXBDE747EK	clear	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FYK9EP525FTA5H44YS	orange	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ75Q2FYMZTDVG9GJSKTPMKP	yelllow	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 19:58:53.435288+00	2026-08-04 22:54:58.363+00	\N	\N
optval_01KZ7FSFSG7XREEAF8YA2XBBBY	gold	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	\N	2026-08-04 22:54:58.248664+00	2026-08-04 22:54:58.248664+00	\N	\N
optval_01KZ6CDM41S19P5YJCJTN4T41Z	gold	opt_01KZ6CDKZ2MB4DN8X3JEMYQ1ER	\N	2026-08-04 12:36:49.514+00	2026-08-04 22:56:15.523+00	2026-08-04 22:56:15.507+00	\N
optval_01KZ7FC71MTHNP8HM5NP3ZJDP5	silver	opt_01KZ6CDKZ2MB4DN8X3JEMYQ1ER	\N	2026-08-04 22:47:43.426266+00	2026-08-04 22:56:15.524+00	2026-08-04 22:56:15.507+00	\N
optval_01KZ6CDM4AK3VVD80RJ6HB6FGJ	black	opt_01KZ6CDKZ3VDN2Q4VJZJY8KX5R	\N	2026-08-04 12:36:49.514+00	2026-08-05 12:17:38.812+00	2026-08-05 12:17:38.768+00	\N
optval_01KZ6CDM4A4ND4SB82G4RPDEAY	white	opt_01KZ6CDKZ3VDN2Q4VJZJY8KX5R	\N	2026-08-04 12:36:49.514+00	2026-08-05 12:17:38.813+00	2026-08-05 12:17:38.768+00	\N
optval_01KZ6CDM4B9EKN61690DEGB4AX	red	opt_01KZ6CDKZ3VDN2Q4VJZJY8KX5R	\N	2026-08-04 12:36:49.514+00	2026-08-05 12:17:38.813+00	2026-08-05 12:17:38.768+00	\N
\.


--
-- Data for Name: product_product_option; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_product_option (id, product_id, product_option_id, created_at, updated_at, deleted_at) FROM stdin;
prodopt_01KYYM12K5BHXH45YJKB7Q5WX1	prod_01KYYM12HNB3B06MTFGRDQ6HER	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	2026-08-01 12:15:51.418+00	2026-08-01 12:15:51.418+00	\N
prodopt_01KZ4ZY9JDVJ7JRP6EEDB6V3RG	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	2026-08-03 23:39:29.753+00	2026-08-03 23:39:29.753+00	\N
prodopt_01KZ6CDME0HH69FVB4J3ZCA4P1	prod_01KZ6CDKYNFYQ8KEWXD75JHSMR	opt_01KZ6CDKZ1CND6KZT55WCK957Z	2026-08-04 12:36:49.778+00	2026-08-04 12:36:49.778+00	\N
prodopt_01KZ6CDME065ZQCNA9GC2T4R0S	prod_01KZ6CDKYNR4MMKW0P0TKPM2EY	opt_01KZ6CDKZ1Q2FARYA8B54EMM2Y	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME21Q8G3RKHEP6DZVHX	prod_01KZ6CDKYN61S7DVMW2DEQXG56	opt_01KZ6CDKZ2FZAKJQXW1QBYSNRX	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME26DM9JBVVZETCE3B6	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	opt_01KZ6CDKZ2C9AQ6HSA2TX01MZ7	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME240263B4C9NTE6Z1K	prod_01KZ6CDKYNSVSVB52D31W5Z60T	opt_01KZ6CDKZ3ZYKM8S5AEVDEXKJZ	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME3CCWC2QRFA2ECB1X1	prod_01KZ6CDKYPM773V64EKZDC8TZ3	opt_01KZ6CDKZ3TS8N63R93RTFMP2J	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME31161YA5PQZWDDR1C	prod_01KZ6CDKYPP489B1SJAPJ484NC	opt_01KZ6CDKZ35PBTXFMR73WDHZCE	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME3NNSDQAAGP2J082C1	prod_01KZ6CDKYP0NXWRGS0S9F7YK07	opt_01KZ6CDKZ3DG1XE5JWJ43RS04V	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME4TR8RCH3VS72ARK0F	prod_01KZ6CDKYP8TPBAEBKDNYT69V1	opt_01KZ6CDKZ4FPJSC5EHWVPQD7QY	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME4TTPSR520YJY7ECBV	prod_01KZ6CDKYQZYC4BQ53JRC9CSD8	opt_01KZ6CDKZ5Z3XWXEYXZD00E910	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME59XTNS265N7QA5YT2	prod_01KZ6CDKYQR48K72DFGE82BV0X	opt_01KZ6CDKZ5QN76WTX65FCSPNEH	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME62KSD9JR22K3P4GHK	prod_01KZ6CDKYQA9WY630Q6ZQAHXAY	opt_01KZ6CDKZ5BGKEZ0M8D12F8YZ2	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME6PPAN0771VCKKVAYY	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	opt_01KZ6CDKZ5A3TYEEQZ71A1BJZG	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME75R07026T3YM51Z80	prod_01KZ6CDKYRZ215S2ACPC8ER0DH	opt_01KZ6CDKZ6JRBFSJH5MMKJEEQE	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME7DT21QZF4CRCGNCQG	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	opt_01KZ6CDKZ6QGYD6RT5H7ABGDJF	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME7EAEYEJW7EHJX47XE	prod_01KZ6CDKYR72K3JFDD9WRHXFMP	opt_01KZ6CDKZ6KK1WM4VBSSXJ1FEJ	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME8N8YK5H1X33AX17SV	prod_01KZ6CDKYR6NPKX84Y57F84V1Q	opt_01KZ6CDKZ6NHFXVZ0DA0TFA9WD	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME8FRRXWF49WAHB5XRW	prod_01KZ6CDKYS41JESCZCY4BCM9FM	opt_01KZ6CDKZ6AE5KEHKW0QR5EBQ7	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME976X2KG0AH0PGVEJY	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B	opt_01KZ6CDKZ7ZD6GVTB2NMS35XRB	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME94JBW1NZH4VB25YM3	prod_01KZ6CDKYST01Z3CFZ1PXH5C76	opt_01KZ6CDKZ70X6Y4E9ZZ7JFRX84	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDME93NSZACRT9WED6322	prod_01KZ6CDKYSH709KDZ998WH03F7	opt_01KZ6CDKZ7H5S1PFDYHEXE0T5R	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEA0683RKTXF43YHP2G	prod_01KZ6CDKYSHC0QM80WW9BRKDEN	opt_01KZ6CDKZ7S5KQSMJ31R724KM8	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEA8CARH1MH9JX1FFB8	prod_01KZ6CDKYT1JZ4CFG3QV6M39SC	opt_01KZ6CDKZ7K3A3V137NHT658HK	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEAB612G9S6B782T035	prod_01KZ6CDKYTAQ19H3S7SES4WHV4	opt_01KZ6CDKZ7KCPV3BPWQCG6E0X0	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEBZY3EXTGRQW1P8DW6	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT	opt_01KZ6CDKZ7W9FZTN4D9GM2A9RJ	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEB4GVVK50NZFK5SS41	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW	opt_01KZ6CDKZ8JEKB8G0S1C505CAR	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEBTAW6C5H35BMN1YNV	prod_01KZ6CDKYVVCPP054QV0XAZGXF	opt_01KZ6CDKZ8Y42JTJ1QZQ1ZE35H	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMECS3YZDQJAE3B6FGJ7	prod_01KZ6CDKYVSGW61NNZPD4KXBWY	opt_01KZ6CDKZ8CD00756AX3KKPZ9P	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMECRXAGRG6DTMGQ1KJ9	prod_01KZ6CDKYW57VVJNPN63K17BJQ	opt_01KZ6CDKZ8G43T4KVA30HS52AJ	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEC6K1TJ94D83KJ8KFT	prod_01KZ6CDKYW57VVJNPN63K17BJQ	opt_01KZ6CDKZ896CT2AA1930NSZS6	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMECZ786KNASDA4KJCP3	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ	opt_01KZ6CDKZ8DFFK82CBBCYYJ0FS	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMEDYQVRGN59D4G296SV	prod_01KZ6CDKYXXTR7F86BCCC30ZR7	opt_01KZ6CDKZ9S7Y9P544GBVJWJ77	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMED859YSKKZQEXH4GN0	prod_01KZ6CDKYX8WKS0VK0PA1MEV6X	opt_01KZ6CDKZ9K8VF4957SQN37VD4	2026-08-04 12:36:49.779+00	2026-08-04 12:36:49.779+00	\N
prodopt_01KZ6CDMED0P9Q6DHPTZMGDDDQ	prod_01KZ6CDKYY4A5TBFR2ETW7PBKE	opt_01KZ6CDKZ97M84FYADCJCSZACR	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEEB5X9TK4R0QHP65G6	prod_01KZ6CDKYY274F77R2WV1ZVGCH	opt_01KZ6CDKZ99T0ZN886DB48ZPB2	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEEA8Q7GWWGWRSR0T61	prod_01KZ6CDKYY82VSC9VRBD393XVG	opt_01KZ6CDKZ91S4NPYATAXDJZXV0	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEFXDMX56HDG17SE3H9	prod_01KZ6CDKYYSXAKPSQNKY2A7W55	opt_01KZ6CDKZ9K44SMACSXSHXEZ5H	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEF1FGMSN3R1RB2NT0B	prod_01KZ6CDKYYR42B0PEP10Y3FT52	opt_01KZ6CDKZA8405237QRDHQ1ZMJ	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEG4T9020D05GV73FA3	prod_01KZ6CDKYZYWXF8070GY5M3PCS	opt_01KZ6CDKZA947AN30ZR986092Y	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEGRYEC6ZKRGMQGS0B8	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F	opt_01KZ6CDKZAP6G0F838DP0ZR8TA	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEG6C4FXYP3Q638FQRQ	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB	opt_01KZ6CDKZAW5ENTDA3QFQYE5TF	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEH2N0FS706AS1RS0MP	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF	opt_01KZ6CDKZAVVRBE82XQ76HN8D2	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	prod_01KZ6CDKZ018SVF05RXG350H68	opt_01KZ6CDKZAV3E99TJYJTXT7EVQ	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEH6TYN6C7R5025ZWBM	prod_01KZ6CDKZ0H2CPWHX4YDE9MWCM	opt_01KZ6CDKZBJMSH64E7HFGMR5KQ	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEJMHRKHFFCN5Q2V9T6	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	opt_01KZ6CDKZBZKZYNNYYFPGPN4YW	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEJ7Y3VKYNG5RCBJYJT	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	opt_01KZ6CDKZB908Y8KEMCYBRPGPF	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEJCQED6QSFVBWA3KQ2	prod_01KZ6CDKZ0ZYP65PJVX991FY70	opt_01KZ6CDKZBTJ4RWFJB21TWN2FD	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEJMW4XYR6PXNY6XQ4K	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM	opt_01KZ6CDKZBQBRF2B6NNXTBDBWJ	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6CDMEKBPC59JKFXAVJXB0Y	prod_01KZ6CDKZ1921PDG5W42Z4XBA6	opt_01KZ6CDKZB4DYT121EX504MQ35	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodopt_01KZ6WJVFB5S1WB6GZ9YNJEPV6	prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ	opt_01KZ6WJVEFP7J8RV7SQARBQRYC	2026-08-04 17:19:17.996+00	2026-08-04 17:19:17.996+00	\N
prodopt_01KZ6Y4FV24EC5GMMJSYG9GA43	prod_01KZ6Y4FTH912SHCT626EJW0XS	opt_01KZ6Y4FTJK6KW53BKH8YZBW3C	2026-08-04 17:46:24.483+00	2026-08-04 17:46:24.483+00	\N
prodopt_01KYYM12K4D09Y3MNXJ57W6JBC	prod_01KYYM12HNB3B06MTFGRDQ6HER	opt_01KYYM12E37TPX938Z7BSMYF9N	2026-08-01 12:15:51.416+00	2026-08-04 19:56:02.136+00	2026-08-04 19:56:02.117+00
prodopt_01KYYM12K62KZV0R395KC980Y3	prod_01KYYM12HPNF1205QN0N30DVZ7	opt_01KYYM12E37TPX938Z7BSMYF9N	2026-08-01 12:15:51.418+00	2026-08-04 19:56:02.136+00	2026-08-04 19:56:02.117+00
prodopt_01KYYM12K6FZJAMZ866S132KKE	prod_01KYYM12HPFK3M2KARA0JVMBZV	opt_01KYYM12E37TPX938Z7BSMYF9N	2026-08-01 12:15:51.418+00	2026-08-04 19:56:02.136+00	2026-08-04 19:56:02.117+00
prodopt_01KYYM12K6H8BM1474HMW6MWMM	prod_01KYYM12HPCG0WKM9PV50YN7NH	opt_01KYYM12E37TPX938Z7BSMYF9N	2026-08-01 12:15:51.419+00	2026-08-04 19:56:02.136+00	2026-08-04 19:56:02.117+00
prodopt_01KZ516X59VX29W4R0NXJARMHA	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	opt_01KYYM12E37TPX938Z7BSMYF9N	2026-08-04 00:01:40.524+00	2026-08-04 19:56:02.137+00	2026-08-04 19:56:02.117+00
prodopt_01KZ7FTCY9719A0MTQHX0CAKZS	prod_01KZ6CDKYN61S7DVMW2DEQXG56	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	2026-08-04 22:55:28.203+00	2026-08-04 22:55:28.203+00	\N
prodopt_01KZ8XQ74HNQKZSNX7E31SZY8W	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	opt_01KYYM12E5S6RCR0PE1ZDH1XGC	2026-08-05 12:17:38.455+00	2026-08-05 12:17:38.455+00	\N
\.


--
-- Data for Name: product_product_option_value; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_product_option_value (id, product_product_option_id, product_option_value_id, created_at, updated_at, deleted_at) FROM stdin;
prodoptval_01KYYM12KB7Z4XST3AKC44KE0A	prodopt_01KYYM12K5BHXH45YJKB7Q5WX1	optval_01KYYM12E4GF1KEEG6W45YHNTG	2026-08-01 12:15:51.421+00	2026-08-01 12:15:51.421+00	\N
prodoptval_01KYYM12KCCN3NZM32DX5WEEXW	prodopt_01KYYM12K5BHXH45YJKB7Q5WX1	optval_01KYYM12E5GP466XZ56SDNBEHC	2026-08-01 12:15:51.421+00	2026-08-01 12:15:51.421+00	\N
prodoptval_01KZ4ZY9JJ9PCW5QP1C0T5CSCH	prodopt_01KZ4ZY9JDVJ7JRP6EEDB6V3RG	optval_01KYYM12E4GF1KEEG6W45YHNTG	2026-08-03 23:39:29.754+00	2026-08-03 23:39:29.754+00	\N
prodoptval_01KZ4ZY9JK9QVF9ZGBMQSYGH14	prodopt_01KZ4ZY9JDVJ7JRP6EEDB6V3RG	optval_01KYYM12E5GP466XZ56SDNBEHC	2026-08-03 23:39:29.755+00	2026-08-03 23:39:29.755+00	\N
prodoptval_01KZ6CDMENRTRWN64TVGJCRJB5	prodopt_01KZ6CDME0HH69FVB4J3ZCA4P1	optval_01KZ6CDM3W28KJ5CB2T0Q3BCKW	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMENB0M31DE9TW9YTJKE	prodopt_01KZ6CDME0HH69FVB4J3ZCA4P1	optval_01KZ6CDM3WA5C0ZZVYV28RPJEA	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMEPYVT2Y4NYH7ABYD9K	prodopt_01KZ6CDME065ZQCNA9GC2T4R0S	optval_01KZ6CDM3YMXP8T2A8SZ31TPDK	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMEQCP3NYAY7W8KBBZKP	prodopt_01KZ6CDME21Q8G3RKHEP6DZVHX	optval_01KZ6CDM42D7N5AVJ6BJAAKERC	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMEQYV1FYC2KGX20EYSP	prodopt_01KZ6CDME21Q8G3RKHEP6DZVHX	optval_01KZ6CDM43ASG18CPQTFTH3Q5N	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMERRTFWFPY0MP1KETF7	prodopt_01KZ6CDME21Q8G3RKHEP6DZVHX	optval_01KZ6CDM43J6E75PPM9T0EG699	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMERAD5S6A0CARWRJ1G0	prodopt_01KZ6CDME21Q8G3RKHEP6DZVHX	optval_01KZ6CDM44GRFAT1NQ41WSA4BJ	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMESWA54M7YM09YF4W6E	prodopt_01KZ6CDME26DM9JBVVZETCE3B6	optval_01KZ6CDM45DKVND48S0VJFCD4C	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMESN2WAPJYCH4CC37X2	prodopt_01KZ6CDME26DM9JBVVZETCE3B6	optval_01KZ6CDM459HTNZH620ZMQ9VZM	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMESSATKNSV84QWBJX8R	prodopt_01KZ6CDME240263B4C9NTE6Z1K	optval_01KZ6CDM46H3SJ8EXB2TM37Y1Z	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMETKZNBTC6SHFPNAN2D	prodopt_01KZ6CDME3CCWC2QRFA2ECB1X1	optval_01KZ6CDM47YHXC0Y2KCWDW9RE8	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMETQRCPBTB21E7GJWX6	prodopt_01KZ6CDME3CCWC2QRFA2ECB1X1	optval_01KZ6CDM4806NTDY0K716PT6JC	2026-08-04 12:36:49.78+00	2026-08-04 12:36:49.78+00	\N
prodoptval_01KZ6CDMEWGPWSN5KSRM44TYK5	prodopt_01KZ6CDME31161YA5PQZWDDR1C	optval_01KZ6CDM4CH9DQDJ36KV9DGPZ0	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEW7MNR97GE4MR4DBHS	prodopt_01KZ6CDME3NNSDQAAGP2J082C1	optval_01KZ6CDM4D9BR267Y0S53NANB1	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEWNTMN6642FBNSFJQR	prodopt_01KZ6CDME4TR8RCH3VS72ARK0F	optval_01KZ6CDM4ESR6SQC81NSQMFSDV	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEXMXH8HQN9P474V403	prodopt_01KZ6CDME4TTPSR520YJY7ECBV	optval_01KZ6CDM4F7JCPS0WXYR7ZQNHW	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEXH0VH2KP66KWAJTAK	prodopt_01KZ6CDME59XTNS265N7QA5YT2	optval_01KZ6CDM4GQ7C3FSST8AGX7EMN	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEXDS6MY82PA5B8YEFN	prodopt_01KZ6CDME62KSD9JR22K3P4GHK	optval_01KZ6CDM4HT9PXV9Y61ST3WXN2	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEYK497H4ERSBCH46H1	prodopt_01KZ6CDME6PPAN0771VCKKVAYY	optval_01KZ6CDM4H3FF7B0EK7VC9RED1	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEY4SC1AWVF07K9MKTZ	prodopt_01KZ6CDME6PPAN0771VCKKVAYY	optval_01KZ6CDM4J2GXRC50795KEHCTY	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEY3A8AAB8EXV8MP50K	prodopt_01KZ6CDME75R07026T3YM51Z80	optval_01KZ6CDM4J0H92EG4BSNWSYCZJ	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEYW8GS7PFP139EXMW1	prodopt_01KZ6CDME7DT21QZF4CRCGNCQG	optval_01KZ6CDM4KE4PYQ1VGVGXCWW3R	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEZ5T0K87CB8HQ6H2CE	prodopt_01KZ6CDME7DT21QZF4CRCGNCQG	optval_01KZ6CDM4KBMEW60CV3B53DZ4T	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMEZCNQDD6JNP9VHJB5X	prodopt_01KZ6CDME7EAEYEJW7EHJX47XE	optval_01KZ6CDM4MDTND9CJS3A4ARX7M	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF0SMGY4PKZFDBH1QNR	prodopt_01KZ6CDME8N8YK5H1X33AX17SV	optval_01KZ6CDM4NSE2R3T1GKK930K67	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF0Z6TN8Y3NGSY8C57T	prodopt_01KZ6CDME8FRRXWF49WAHB5XRW	optval_01KZ6CDM4N0W6KD19HYCJK05ZH	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF1AVH9FW8PSX9F13EA	prodopt_01KZ6CDME976X2KG0AH0PGVEJY	optval_01KZ6CDM4PNS7JB9J5AFGW8HT3	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF1Z1FVR5SWF8J2PPR4	prodopt_01KZ6CDME94JBW1NZH4VB25YM3	optval_01KZ6CDM4PWJXTJ8XSE8X3329H	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF1827KA1X9D2F8G9W8	prodopt_01KZ6CDME94JBW1NZH4VB25YM3	optval_01KZ6CDM4QJ8Q6AQ43FAV5MV5Q	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF20WXBMANGDEVR45XN	prodopt_01KZ6CDME94JBW1NZH4VB25YM3	optval_01KZ6CDM4RRX2F5CDDC7BMF2KA	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF20GW5E7HDCPEWWDJP	prodopt_01KZ6CDME94JBW1NZH4VB25YM3	optval_01KZ6CDM4S8Y24SK7KAHGHE90B	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF2JRNA3XR6ME7P0EDV	prodopt_01KZ6CDME93NSZACRT9WED6322	optval_01KZ6CDM4T72AGF4W020M8R65X	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF32XEMJ2TAB95Y0JA7	prodopt_01KZ6CDMEA0683RKTXF43YHP2G	optval_01KZ6CDM4VCTKCSP46YYJ99ZAQ	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF36G44TRMY710V05KP	prodopt_01KZ6CDMEA8CARH1MH9JX1FFB8	optval_01KZ6CDM4WX0JF3DHJ9MNC6MVD	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF3N73184XSJES0Q5TG	prodopt_01KZ6CDMEAB612G9S6B782T035	optval_01KZ6CDM4XZ043QC52ZSTC8PQJ	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF3VVQYW2CA72Z9TFM8	prodopt_01KZ6CDMEBZY3EXTGRQW1P8DW6	optval_01KZ6CDM4X1G0SDBNBW728YVP6	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF4YVWBXRDJANZEEFP4	prodopt_01KZ6CDMEB4GVVK50NZFK5SS41	optval_01KZ6CDM4YFDTPR41VK295CWW3	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF47K00TE110QW4BVJC	prodopt_01KZ6CDMEBTAW6C5H35BMN1YNV	optval_01KZ6CDM4Z5TCNE79VCX1T4VC1	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF4DRB4BZVCPX6R8S5Q	prodopt_01KZ6CDMECS3YZDQJAE3B6FGJ7	optval_01KZ6CDM500W1GD1H173X7WT5H	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF51YZBDH7MAAGVZ12Y	prodopt_01KZ6CDMECRXAGRG6DTMGQ1KJ9	optval_01KZ6CDM51ZJ3ZMR8CSKTRG04C	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF5J44D8TT6A6G0GR3Q	prodopt_01KZ6CDMECRXAGRG6DTMGQ1KJ9	optval_01KZ6CDM529NBZS3KY4G2CFGAG	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF5E4E7VBRCM2HPTQV9	prodopt_01KZ6CDMEC6K1TJ94D83KJ8KFT	optval_01KZ6CDM539S56WJKSMMZQZ8QG	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF6FWXE8FCW4TSP3ASX	prodopt_01KZ6CDMECZ786KNASDA4KJCP3	optval_01KZ6CDM54EGVN6P7KGG65NY3M	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF6CNPN4Q1C01E3ZH63	prodopt_01KZ6CDMEDYQVRGN59D4G296SV	optval_01KZ6CDM555ZW57TMGB35SKW6Z	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF6XKSP42E0PYH9K0XM	prodopt_01KZ6CDMED859YSKKZQEXH4GN0	optval_01KZ6CDM55D828K3FT5XJ6VJW5	2026-08-04 12:36:49.781+00	2026-08-04 12:36:49.781+00	\N
prodoptval_01KZ6CDMF7M4HECP0XYK050564	prodopt_01KZ6CDMED0P9Q6DHPTZMGDDDQ	optval_01KZ6CDM58F1BTYF0SFZ5469KX	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF7FV3J8TJ37FZ2RPMP	prodopt_01KZ6CDMED0P9Q6DHPTZMGDDDQ	optval_01KZ6CDM592MTFBTXW1R2E5M4Y	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF786A6D1RMYDQ8CV75	prodopt_01KZ6CDMEEB5X9TK4R0QHP65G6	optval_01KZ6CDM594XE5XJ237T3HGGRY	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF79GE6T6MQ5RMSHAWW	prodopt_01KZ6CDMEEB5X9TK4R0QHP65G6	optval_01KZ6CDM5AR7G5RXPW84G3BJN7	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF80WB2WQE5GS1D25QK	prodopt_01KZ6CDMEEA8Q7GWWGWRSR0T61	optval_01KZ6CDM5B14HDBG0V0P3XF2FD	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF8QPQRY50VVN4AKSHD	prodopt_01KZ6CDMEFXDMX56HDG17SE3H9	optval_01KZ6CDM5CSR6K28005PWYFDJ5	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF83TKAB8S6D7J9S8RB	prodopt_01KZ6CDMEF1FGMSN3R1RB2NT0B	optval_01KZ6CDM5DC2FCCVF2N8BZTFTN	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF91FCA4BYYJZCQW7G6	prodopt_01KZ6CDMEG4T9020D05GV73FA3	optval_01KZ6CDM5EMWZ98YMGCYZF6X89	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF9YW5V62JX8WPAD6JA	prodopt_01KZ6CDMEGRYEC6ZKRGMQGS0B8	optval_01KZ6CDM5FGP487868D51CQ58Q	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMF97DMMZ24TSW4T7F2V	prodopt_01KZ6CDMEG6C4FXYP3Q638FQRQ	optval_01KZ6CDM5GBXK2BKA9DPQBS5S7	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFAP1QVHAB7R2241VCP	prodopt_01KZ6CDMEG6C4FXYP3Q638FQRQ	optval_01KZ6CDM5GV1YHV6RA166SABS9	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFA9Z8S7DX2D15FEDZW	prodopt_01KZ6CDMEG6C4FXYP3Q638FQRQ	optval_01KZ6CDM5GA4D497QXKTV8E4D1	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFA9TGDWKXDS6MDTSAS	prodopt_01KZ6CDMEH2N0FS706AS1RS0MP	optval_01KZ6CDM5H2JKWTG9SGK6SFX4W	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFBSG880NWQQ54CB6PT	prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	optval_01KZ6CDM5JCKH1XKEYG8MPC4M3	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFBBPJR29KGET9KSBNY	prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	optval_01KZ6CDM5JJ7HV38ER0YNKAAC8	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFBC8ASRGYPKFS0Z4TB	prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	optval_01KZ6CDM5KJ6EEB6C8WAAT44VW	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFCJ2BXQV7WKEVRC376	prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	optval_01KZ6CDM5KGP3AD6HP38120VQR	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFCXCMG1VJKZTMVB0KF	prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	optval_01KZ6CDM5MKSNY67SWV0N6JS8F	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFCVNJQPJK391546AZA	prodopt_01KZ6CDMEH59KJ9TMW753DYWN5	optval_01KZ6CDM5MWVCD58SSWJ47N15Q	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFDTT8DE9QQDNY016NG	prodopt_01KZ6CDMEH6TYN6C7R5025ZWBM	optval_01KZ6CDM5NBC5861V8TCZ325S2	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFD0TYB290XFD4F0VW5	prodopt_01KZ6CDMEJMHRKHFFCN5Q2V9T6	optval_01KZ6CDM5P208EKYEDECEKWEV4	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFD42GSAT0VM2GRG6DA	prodopt_01KZ6CDMEJMHRKHFFCN5Q2V9T6	optval_01KZ6CDM5Q8QYJ024CJ6P86GYF	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFEX9D3891QRD25TCX1	prodopt_01KZ6CDMEJMHRKHFFCN5Q2V9T6	optval_01KZ6CDM5Q21JGJ33QR2MS6SWA	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFEFDXABZ770HYZ94J7	prodopt_01KZ6CDMEJ7Y3VKYNG5RCBJYJT	optval_01KZ6CDM5RXG46W504GMPXN4HZ	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFEF22K0CWTJZ14J2WJ	prodopt_01KZ6CDMEJ7Y3VKYNG5RCBJYJT	optval_01KZ6CDM5SW5W8GN7NRJCYPT1H	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFF8SY6AA27BJNDZ0VV	prodopt_01KZ6CDMEJCQED6QSFVBWA3KQ2	optval_01KZ6CDM5SSGKX05JEEZBX67DZ	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFFZY5897SREZV94EF2	prodopt_01KZ6CDMEJMW4XYR6PXNY6XQ4K	optval_01KZ6CDM5VC3PZMKC1RA13G4Y4	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6CDMFFM2S12SVKMDQMRZDQ	prodopt_01KZ6CDMEKBPC59JKFXAVJXB0Y	optval_01KZ6CDM5WCS72Q798ZPN1EQWD	2026-08-04 12:36:49.782+00	2026-08-04 12:36:49.782+00	\N
prodoptval_01KZ6WJVFBH8Q7RJ56G9Y8XYNG	prodopt_01KZ6WJVFB5S1WB6GZ9YNJEPV6	optval_01KZ6WJVEHC52BAJJ7FS9VD4V6	2026-08-04 17:19:17.996+00	2026-08-04 17:19:17.996+00	\N
prodoptval_01KZ6Y4FV2QZBESAKXSHK6X1MA	prodopt_01KZ6Y4FV24EC5GMMJSYG9GA43	optval_01KZ6Y4FTKAHXAKPTZSE9YWYBT	2026-08-04 17:46:24.483+00	2026-08-04 17:46:24.483+00	\N
prodoptval_01KYYM12K96YRM9QDB8NW55RR8	prodopt_01KYYM12K4D09Y3MNXJ57W6JBC	optval_01KYYM12E0DHAHVYGXWQ57V8JX	2026-08-01 12:15:51.419+00	2026-08-04 19:56:02.132+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KAPH8YFVJQMY1VZ0S9	prodopt_01KYYM12K4D09Y3MNXJ57W6JBC	optval_01KYYM12E1W92RPVQ879TJWH0G	2026-08-01 12:15:51.42+00	2026-08-04 19:56:02.132+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KACVC15CPC7MXVXJHN	prodopt_01KYYM12K4D09Y3MNXJ57W6JBC	optval_01KYYM12E1AWWQJ28K70F972FQ	2026-08-01 12:15:51.42+00	2026-08-04 19:56:02.132+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KBX2EBW3ZCWA81972S	prodopt_01KYYM12K4D09Y3MNXJ57W6JBC	optval_01KYYM12E2MGPF8547CKSXC4NE	2026-08-01 12:15:51.42+00	2026-08-04 19:56:02.132+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KC87D6C04N5VKH1VC2	prodopt_01KYYM12K62KZV0R395KC980Y3	optval_01KYYM12E0DHAHVYGXWQ57V8JX	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.132+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KDXPGP1Z2EDYHFVNP9	prodopt_01KYYM12K62KZV0R395KC980Y3	optval_01KYYM12E1W92RPVQ879TJWH0G	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.132+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KETAN86QFMWME630JY	prodopt_01KYYM12K62KZV0R395KC980Y3	optval_01KYYM12E1AWWQJ28K70F972FQ	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.133+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KETXKJY9WVQ43CX3VE	prodopt_01KYYM12K62KZV0R395KC980Y3	optval_01KYYM12E2MGPF8547CKSXC4NE	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.133+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KF4Q0V6Q8399CA13KG	prodopt_01KYYM12K6FZJAMZ866S132KKE	optval_01KYYM12E0DHAHVYGXWQ57V8JX	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.133+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KFVHCGQTNBFVDSNHA1	prodopt_01KYYM12K6FZJAMZ866S132KKE	optval_01KYYM12E1W92RPVQ879TJWH0G	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.133+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KGVYJQ5SED4C75B5K2	prodopt_01KYYM12K6FZJAMZ866S132KKE	optval_01KYYM12E1AWWQJ28K70F972FQ	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.134+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KG0MS7FFMQS3CHV87H	prodopt_01KYYM12K6FZJAMZ866S132KKE	optval_01KYYM12E2MGPF8547CKSXC4NE	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.134+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KGXKY3S6XYYPETXBY4	prodopt_01KYYM12K6H8BM1474HMW6MWMM	optval_01KYYM12E0DHAHVYGXWQ57V8JX	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.134+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KGBRXY1SR20JW0KHQS	prodopt_01KYYM12K6H8BM1474HMW6MWMM	optval_01KYYM12E1W92RPVQ879TJWH0G	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.134+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KHV340C9WYQ0N8GSNS	prodopt_01KYYM12K6H8BM1474HMW6MWMM	optval_01KYYM12E1AWWQJ28K70F972FQ	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.134+00	2026-08-04 19:56:02.097+00
prodoptval_01KYYM12KH7CE3GXNS4YWTAHSQ	prodopt_01KYYM12K6H8BM1474HMW6MWMM	optval_01KYYM12E2MGPF8547CKSXC4NE	2026-08-01 12:15:51.421+00	2026-08-04 19:56:02.135+00	2026-08-04 19:56:02.097+00
prodoptval_01KZ516X5A9BN18YVTK81F5VCP	prodopt_01KZ516X59VX29W4R0NXJARMHA	optval_01KYYM12E1AWWQJ28K70F972FQ	2026-08-04 00:01:40.524+00	2026-08-04 19:56:02.135+00	2026-08-04 19:56:02.097+00
prodoptval_01KZ516X5BBSFGVDBB4V636YB6	prodopt_01KZ516X59VX29W4R0NXJARMHA	optval_01KYYM12E1W92RPVQ879TJWH0G	2026-08-04 00:01:40.524+00	2026-08-04 19:56:02.135+00	2026-08-04 19:56:02.097+00
prodoptval_01KZ516X5BZ2R4NABSH1AWHDVB	prodopt_01KZ516X59VX29W4R0NXJARMHA	optval_01KYYM12E0DHAHVYGXWQ57V8JX	2026-08-04 00:01:40.525+00	2026-08-04 19:56:02.135+00	2026-08-04 19:56:02.097+00
prodoptval_01KZ7FTCYAYJZ6EK8XEM6PHVY9	prodopt_01KZ7FTCY9719A0MTQHX0CAKZS	optval_01KZ7FSFSG7XREEAF8YA2XBBBY	2026-08-04 22:55:28.203+00	2026-08-04 22:55:28.203+00	\N
prodoptval_01KZ7FTCYB10Y1W7VXJA64ZTA2	prodopt_01KZ7FTCY9719A0MTQHX0CAKZS	optval_01KZ75Q2FSFKVX3NZ33F2QEMXE	2026-08-04 22:55:28.203+00	2026-08-04 22:55:28.203+00	\N
prodoptval_01KZ8XQ74J5NCF6P5T30RCMMJC	prodopt_01KZ8XQ74HNQKZSNX7E31SZY8W	optval_01KYYM12E4GF1KEEG6W45YHNTG	2026-08-05 12:17:38.455+00	2026-08-05 12:17:38.455+00	\N
prodoptval_01KZ8XQ74J52QZXF565Z9149HG	prodopt_01KZ8XQ74HNQKZSNX7E31SZY8W	optval_01KZ75Q2FQQ2XX0TPCDD4FMWQF	2026-08-05 12:17:38.455+00	2026-08-05 12:17:38.455+00	\N
prodoptval_01KZ8XQ74K0KVR45HTS1NKK8KN	prodopt_01KZ8XQ74HNQKZSNX7E31SZY8W	optval_01KZ75Q2FWX3TTSHW91BYT2X8P	2026-08-05 12:17:38.455+00	2026-08-05 12:17:38.455+00	\N
prodoptval_01KZ8XQ74NPVPZZW0Z8DVZSND6	prodopt_01KZ8XQ74HNQKZSNX7E31SZY8W	optval_01KYYM12E5GP466XZ56SDNBEHC	2026-08-05 12:17:38.455+00	2026-08-05 12:17:38.455+00	\N
prodoptval_01KZ8XQ74PPVRMHX4WY9J8M32S	prodopt_01KZ8XQ74HNQKZSNX7E31SZY8W	optval_01KZ75Q2FVGEQYW0B6QDVEJTE6	2026-08-05 12:17:38.455+00	2026-08-05 12:17:38.455+00	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KZ4ZY9WDK8SMGF0Z09KA5R1E	2026-08-03 23:39:29.880005+00	2026-08-04 12:40:32.404+00	2026-08-04 12:40:32.4+00
prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KZ6WJVHHWWYZF00VX22GXX66	2026-08-04 17:19:18.08602+00	2026-08-04 17:19:18.08602+00	\N
prod_01KYYM12HNB3B06MTFGRDQ6HER	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KYYM12XGFXTJ8GQA8X10GDKA	2026-08-01 12:15:51.766432+00	2026-08-04 17:20:30.521+00	2026-08-04 17:20:30.52+00
prod_01KYYM12HPCG0WKM9PV50YN7NH	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KYYM12XPE1PWBTFVFVXEPMD3	2026-08-01 12:15:51.766432+00	2026-08-04 17:20:33.39+00	2026-08-04 17:20:33.389+00
prod_01KYYM12HPFK3M2KARA0JVMBZV	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KYYM12XNE22ZV9AYSW5SNS6F	2026-08-01 12:15:51.766432+00	2026-08-04 17:20:36.686+00	2026-08-04 17:20:36.685+00
prod_01KYYM12HPNF1205QN0N30DVZ7	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KYYM12XKB5TANV4XNBWAHJ3N	2026-08-01 12:15:51.766432+00	2026-08-04 17:20:40.407+00	2026-08-04 17:20:40.406+00
prod_01KZ6Y4FTH912SHCT626EJW0XS	sc_01KYYM10T2S0GBNVGXG96MYD0X	prodsc_01KZ6Y4FWF8JRRPGA76E73MZX4	2026-08-04 17:46:24.579522+00	2026-08-04 17:46:24.579522+00	\N
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ	sp_01KYYM1072RRG3RWZGWTPAENCV	prodsp_01KZ6WJVJ4NNM0EN1TQ3V27V20	2026-08-04 17:19:18.105644+00	2026-08-04 17:19:18.105644+00	\N
prod_01KYYM12HNB3B06MTFGRDQ6HER	sp_01KYYM1072RRG3RWZGWTPAENCV	prodsp_01KYYM130CPQY93NG4ACBHW5Y2	2026-08-01 12:15:51.861152+00	2026-08-04 17:20:30.533+00	2026-08-04 17:20:30.533+00
prod_01KYYM12HPCG0WKM9PV50YN7NH	sp_01KYYM1072RRG3RWZGWTPAENCV	prodsp_01KYYM130HWT0RJ9JYZMF2KADN	2026-08-01 12:15:51.861152+00	2026-08-04 17:20:33.392+00	2026-08-04 17:20:33.391+00
prod_01KYYM12HPFK3M2KARA0JVMBZV	sp_01KYYM1072RRG3RWZGWTPAENCV	prodsp_01KYYM130G60WJW8GMPDMRHAX6	2026-08-01 12:15:51.861152+00	2026-08-04 17:20:36.682+00	2026-08-04 17:20:36.682+00
prod_01KYYM12HPNF1205QN0N30DVZ7	sp_01KYYM1072RRG3RWZGWTPAENCV	prodsp_01KYYM130FE15EPEXNFNCA2RPM	2026-08-01 12:15:51.861152+00	2026-08-04 17:20:40.411+00	2026-08-04 17:20:40.411+00
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at, external_id) FROM stdin;
ptag_01KZ76BG1WF5R01RGZ96RTPT43	bracelet	\N	2026-08-04 20:10:02.685+00	2026-08-04 20:10:02.685+00	\N	\N
ptag_01KZ76BWHXJE73CH0EQ52GFHS1	ring	\N	2026-08-04 20:10:15.486+00	2026-08-04 20:10:15.486+00	\N	\N
ptag_01KZ76C7N2SGCQQF4CWP58JFY5	pendent	\N	2026-08-04 20:10:26.852+00	2026-08-04 20:10:26.852+00	\N	\N
ptag_01KZ76CGXYGD4KNGJP77JC1RR5	earring	\N	2026-08-04 20:10:36.352+00	2026-08-04 20:10:36.352+00	\N	\N
ptag_01KZ76D1HK6A2XQ2AX735Y8KB9	earcuffs	\N	2026-08-04 20:10:53.364+00	2026-08-04 20:10:53.364+00	\N	\N
ptag_01KZ76DXK460QXHDFGGFRPRVRR	necklace	\N	2026-08-04 20:11:22.084+00	2026-08-04 20:11:22.084+00	\N	\N
ptag_01KZ76E9NQBCEFDX3ZTAFZSCXW	combo	\N	2026-08-04 20:11:34.456+00	2026-08-04 20:11:34.456+00	\N	\N
ptag_01KZ76EKFQJATZWSGKYX888TK5	ear	\N	2026-08-04 20:11:44.503+00	2026-08-04 20:11:44.503+00	\N	\N
ptag_01KZ76F07ZNP3Y4B1D5MBAQBJT	pod	\N	2026-08-04 20:11:57.568+00	2026-08-04 20:11:57.568+00	\N	\N
ptag_01KZ76GECDM19KSNQZF0GPMKYJ	set	\N	2026-08-04 20:12:44.814+00	2026-08-04 20:12:44.814+00	\N	\N
ptag_01KZ76H3F2P640X7HV3MJHXX00	studs	\N	2026-08-04 20:13:06.403+00	2026-08-04 20:13:06.403+00	\N	\N
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
prod_01KZ6CDKYNFYQ8KEWXD75JHSMR	ptag_01KZ76C7N2SGCQQF4CWP58JFY5
prod_01KZ6CDKYN61S7DVMW2DEQXG56	ptag_01KZ76BG1WF5R01RGZ96RTPT43
prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	ptag_01KZ76D1HK6A2XQ2AX735Y8KB9
prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYNR4MMKW0P0TKPM2EY	ptag_01KZ76C7N2SGCQQF4CWP58JFY5
prod_01KZ6CDKYNSVSVB52D31W5Z60T	ptag_01KZ76BG1WF5R01RGZ96RTPT43
prod_01KZ6CDKYP0NXWRGS0S9F7YK07	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYP8TPBAEBKDNYT69V1	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYPDQG0QDKT37MDDPA3	ptag_01KZ76BG1WF5R01RGZ96RTPT43
prod_01KZ6CDKYPM773V64EKZDC8TZ3	ptag_01KZ76D1HK6A2XQ2AX735Y8KB9
prod_01KZ6CDKYPM773V64EKZDC8TZ3	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYPP489B1SJAPJ484NC	ptag_01KZ76DXK460QXHDFGGFRPRVRR
prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	ptag_01KZ76C7N2SGCQQF4CWP58JFY5
prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	ptag_01KZ76DXK460QXHDFGGFRPRVRR
prod_01KZ6CDKYQA9WY630Q6ZQAHXAY	ptag_01KZ76C7N2SGCQQF4CWP58JFY5
prod_01KZ6CDKYQR48K72DFGE82BV0X	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYQZYC4BQ53JRC9CSD8	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYQZYC4BQ53JRC9CSD8	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	ptag_01KZ76C7N2SGCQQF4CWP58JFY5
prod_01KZ6CDKYR6NPKX84Y57F84V1Q	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYR6NPKX84Y57F84V1Q	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYR72K3JFDD9WRHXFMP	ptag_01KZ76DXK460QXHDFGGFRPRVRR
prod_01KZ6CDKYRZ215S2ACPC8ER0DH	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYRZ215S2ACPC8ER0DH	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYS41JESCZCY4BCM9FM	ptag_01KZ76CGXYGD4KNGJP77JC1RR5
prod_01KZ6CDKYS41JESCZCY4BCM9FM	ptag_01KZ76EKFQJATZWSGKYX888TK5
prod_01KZ6CDKYSCZ5V05NQEKZQHW9B	ptag_01KZ76GECDM19KSNQZF0GPMKYJ
prod_01KZ6CDKYSCZ5V05NQEKZQHW9B	ptag_01KZ76E9NQBCEFDX3ZTAFZSCXW
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at, external_id) FROM stdin;
ptyp_01KZ768K05VPN64CJV28KQKGBC	bracelet	\N	2026-08-04 20:08:27.399+00	2026-08-04 20:08:27.399+00	\N	\N
ptyp_01KZ76939CWWD3BS46NNTXRMQZ	ear cuff	\N	2026-08-04 20:08:44.077+00	2026-08-04 20:08:44.077+00	\N	\N
ptyp_01KZ769HJN6BMG6MZN38MW1QZT	earring	\N	2026-08-04 20:08:58.71+00	2026-08-04 20:08:58.71+00	\N	\N
ptyp_01KZ76A05F5A855JCH5KCBCYZM	pendent	\N	2026-08-04 20:09:13.649+00	2026-08-04 20:09:13.649+00	\N	\N
ptyp_01KZ76ADPERKJCRN0GJSZ5P4QJ	ring	\N	2026-08-04 20:09:27.502+00	2026-08-04 20:09:27.502+00	\N	\N
ptyp_01KZ76APX77E9WACSXDCJ7FSBS	set	\N	2026-08-04 20:09:36.936+00	2026-08-04 20:09:36.936+00	\N	\N
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at, thumbnail) FROM stdin;
variant_01KZ8XR8CFJK8BSJGYD2793PY1	Green	Tennis-green	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-05 12:18:12.497+00	2026-08-05 12:22:30.173+00	\N	\N
variant_01KZ8Y1YJ5B7B01RA7EPJYV4S9	Red	Tennis-red	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-05 12:23:30.122+00	2026-08-05 12:23:30.122+00	\N	\N
variant_01KZ8Y2P3AG1XR85T301TYPVND	White	Tennis-white	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-05 12:23:54.22+00	2026-08-05 12:23:54.22+00	\N	\N
variant_01KYYM133ZHK2BPR0KGJCTFT18	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.949+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM1340J2REVFW5EWJQZBDG	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM1341B5044GXK40CJMJWS	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM134234VY30GKJKYR1XXD	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM1343PRJJH61TXGN2HFN9	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM1344YXSMB3Z9PJ1RD690	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM1344NRBNDRH7CHJEMNG1	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM1345FZGQVZ3RPRD4PDWY	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HNB3B06MTFGRDQ6HER	2026-08-01 12:15:51.95+00	2026-08-04 17:20:30.551+00	2026-08-04 17:20:30.531+00	\N
variant_01KYYM134BRDWRDNWCJHSJWPAH	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPCG0WKM9PV50YN7NH	2026-08-01 12:15:51.951+00	2026-08-04 17:20:33.405+00	2026-08-04 17:20:33.386+00	\N
variant_01KYYM134BG6QZAAFWQC3WMVNA	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPCG0WKM9PV50YN7NH	2026-08-01 12:15:51.951+00	2026-08-04 17:20:33.405+00	2026-08-04 17:20:33.386+00	\N
variant_01KYYM134C8ET3CWTKBBS42QSM	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPCG0WKM9PV50YN7NH	2026-08-01 12:15:51.951+00	2026-08-04 17:20:33.405+00	2026-08-04 17:20:33.386+00	\N
variant_01KYYM134CFKQZHN8JWQXRHYCS	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPCG0WKM9PV50YN7NH	2026-08-01 12:15:51.951+00	2026-08-04 17:20:33.405+00	2026-08-04 17:20:33.386+00	\N
variant_01KYYM13493XK7BS9PBRXRB5XG	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPFK3M2KARA0JVMBZV	2026-08-01 12:15:51.951+00	2026-08-04 17:20:36.698+00	2026-08-04 17:20:36.673+00	\N
variant_01KYYM13493KRR0HAJ4YTV1852	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPFK3M2KARA0JVMBZV	2026-08-01 12:15:51.951+00	2026-08-04 17:20:36.699+00	2026-08-04 17:20:36.673+00	\N
variant_01KYYM134AM5ZTADTCSKY5N0P1	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPFK3M2KARA0JVMBZV	2026-08-01 12:15:51.951+00	2026-08-04 17:20:36.699+00	2026-08-04 17:20:36.673+00	\N
variant_01KYYM134A5BPK0XVMP8SD1NC2	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPFK3M2KARA0JVMBZV	2026-08-01 12:15:51.951+00	2026-08-04 17:20:36.699+00	2026-08-04 17:20:36.673+00	\N
variant_01KYYM1346Q953HWSPSKGB3HWK	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPNF1205QN0N30DVZ7	2026-08-01 12:15:51.95+00	2026-08-04 17:20:40.422+00	2026-08-04 17:20:40.404+00	\N
variant_01KYYM13474S1J1ZVMZC66YZ95	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPNF1205QN0N30DVZ7	2026-08-01 12:15:51.95+00	2026-08-04 17:20:40.422+00	2026-08-04 17:20:40.404+00	\N
variant_01KYYM1348EF4TKZA541F1F59G	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPNF1205QN0N30DVZ7	2026-08-01 12:15:51.951+00	2026-08-04 17:20:40.422+00	2026-08-04 17:20:40.404+00	\N
variant_01KYYM1348KMK8ECJ9EVHF6XT5	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KYYM12HPNF1205QN0N30DVZ7	2026-08-01 12:15:51.951+00	2026-08-04 17:20:40.422+00	2026-08-04 17:20:40.404+00	\N
variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	Blue	Tennis-blue	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-05 12:22:11.063+00	2026-08-05 12:22:11.063+00	\N	\N
variant_01KZ6CDN099BRKMZH8A2C73YF6	Gold	Butterflies - gold	\N	\N	\N	f	t	\N	\N	\N	gold	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPM773V64EKZDC8TZ3	2026-08-04 12:36:50.36+00	2026-08-05 12:30:57.919+00	\N	\N
variant_01KZ6CDN09M50P581MG6ZSVJG3	Silver	Butterflies - silver	\N	\N	\N	t	t	\N	\N	\N	silver	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPM773V64EKZDC8TZ3	2026-08-04 12:36:50.36+00	2026-08-05 12:31:55.229+00	\N	\N
variant_01KZ6CDN0K939YV5FA1MY0ET8V	Silver	Emerald Drops-Silver	\N	\N	\N	f	t	\N	\N	\N	\N	600	\N	\N	\N	\N	0	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	2026-08-04 12:36:50.36+00	2026-08-05 12:37:33.968+00	\N	\N
variant_01KZ6CDN0M5W17E3B90MHTWGP1	Gold	Emerald Drops-Gold	\N	\N	\N	f	t	\N	\N	\N	\N	600	\N	\N	\N	\N	0	prod_01KZ6CDKYQ1GJXFRHEFHWQ4Q3W	2026-08-04 12:36:50.36+00	2026-08-05 12:38:02.24+00	\N	\N
variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	silver	fettuccine-silver	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	2026-08-04 12:36:50.36+00	2026-08-05 12:46:04.639+00	\N	\N
variant_01KZ6CDN0P9DETBPWK54M1K7AM	gold	fettuccine-gold	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYR2JDN3KZT0NKTWEP1	2026-08-04 12:36:50.36+00	2026-08-05 12:47:20.851+00	\N	\N
variant_01KZ6CDN0Q29QE56892FQQ1MP6	Forever Flower	Forever Flower	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	{"vendor": "Strawb"}	0	prod_01KZ6CDKYR72K3JFDD9WRHXFMP	2026-08-04 12:36:50.361+00	2026-08-05 12:51:48.265+00	\N	\N
variant_01KZ6CDN0RFPEPFGWN4RW27EZM	Golden Geometry	Golden Geometry	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	{"vendor": "vembley"}	0	prod_01KZ6CDKYS41JESCZCY4BCM9FM	2026-08-04 12:36:50.361+00	2026-08-05 12:55:20.152+00	\N	\N
variant_01KZ6CDMZYBWZ3RGMVCTK1WV79	And Forever - silver	And Forever - silver	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYNFYQ8KEWXD75JHSMR	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDMZZB1YAKW2PQAZR6KWY	khdz004	khdz004	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYNR4MMKW0P0TKPM2EY	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN058P9B4TRNRBWAQ4MF	Blingers - gold	Blingers - gold	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN06ANBG61KQ092TD09Y	Blingers - silver	Blingers - silver	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYNE96CEMXTZZ7MG9HA	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN07A7W4Q0CTB3KVAQVD	buckle up	buckle up	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYNSVSVB52D31W5Z60T	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	Cherry	Cherry	\N	\N	\N	f	t	\N	\N	\N	\N	50	\N	\N	\N	\N	0	prod_01KZ6CDKYPP489B1SJAPJ484NC	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0EWX32JPFVCY99JTZ0	cherry-earrings	cherry-earrings	\N	\N	\N	f	t	\N	\N	\N	\N	60	\N	\N	\N	\N	0	prod_01KZ6CDKYP0NXWRGS0S9F7YK07	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0GMBY55W7PG3R0MFJ8	DoubleDrama	DoubleDrama	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYP8TPBAEBKDNYT69V1	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0GQNTK1HFBJ09HS9PC	DG	DG	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYQZYC4BQ53JRC9CSD8	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0H6QCATENB9WDW6BEJ	Ear candy	Ear candy	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYQR48K72DFGE82BV0X	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0JPQ4EDYBNDMQ0PN93	Teardrop	Teardrop	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYQA9WY630Q6ZQAHXAY	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	everyday	everyday	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYRZ215S2ACPC8ER0DH	2026-08-04 12:36:50.36+00	2026-08-04 12:36:50.36+00	\N	\N
variant_01KZ6CDN0RZDNFJW993VCF7RJ8	Golden Dots	Golden Dots	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYR6NPKX84Y57F84V1Q	2026-08-04 12:36:50.361+00	2026-08-04 12:36:50.361+00	\N	\N
variant_01KZ6CDN0SBFFRP1A7S1D6Y351	Green Set	Green Set	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYSCZ5V05NQEKZQHW9B	2026-08-04 12:36:50.361+00	2026-08-04 12:36:50.361+00	\N	\N
variant_01KZ6CDN0TFW3DJNQV7M0691K9	fettuccine-1	fettuccine-1	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYST01Z3CFZ1PXH5C76	2026-08-04 12:36:50.361+00	2026-08-04 12:36:50.361+00	\N	\N
variant_01KZ6CDN0VQNKDJW120N0QSQM7	fettuccine-2	fettuccine-2	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYST01Z3CFZ1PXH5C76	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0VW3RPYF9QWCMH80WJ	fettuccine-3	fettuccine-3	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYST01Z3CFZ1PXH5C76	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0W0VPNG6BG2Z3EPVZ7	fettuccine-4	fettuccine-4	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYST01Z3CFZ1PXH5C76	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0WVX41RE2H9B3Q197Q	IJAG - Rose Gold	IJAG - Rose Gold	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYSH709KDZ998WH03F7	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0WGKN5TNBCHB5WDGGH	loop	loop	\N	\N	\N	f	t	\N	\N	\N	\N	100	\N	\N	\N	\N	0	prod_01KZ6CDKYSHC0QM80WW9BRKDEN	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0XWXNPZR007HQYRX3M	MAS	MAS	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYT1JZ4CFG3QV6M39SC	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0XWWWH64PC687DE3Z1	Mermaids Necklace - Forever Flower	Mermaids Necklace - Forever Flower	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYTAQ19H3S7SES4WHV4	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0YQWTYZPRG4PHWJ9YS	Mirchi	Mirchi	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYT8BWSMYXVRH3HD1JT	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0Y0JRBHYMN7FCK2C3E	My Heart	My Heart	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYVAB6E3QJV4YFT0RBW	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0Z1W5V4F1EN8ZADXEZ	Ocean Drop	Ocean Drop	\N	\N	\N	f	t	\N	\N	\N	\N	48	\N	\N	\N	\N	0	prod_01KZ6CDKYVVCPP054QV0XAZGXF	2026-08-04 12:36:50.365+00	2026-08-04 12:36:50.365+00	\N	\N
variant_01KZ6CDN0ZJCMTNHW5GWXNHKST	OSC	OSC	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYVSGW61NNZPD4KXBWY	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN00E12E60Q3673HEK7V	BB - 1	BB - 1	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 12:36:50.36+00	2026-08-04 22:55:44.015+00	2026-08-04 22:55:44.014+00	\N
variant_01KZ6CDN0191F12MKM5N7MX34Y	BB - 2	BB - 2	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 12:36:50.36+00	2026-08-04 22:55:48.731+00	2026-08-04 22:55:48.73+00	\N
variant_01KZ6CDN03DKSN2Q4B94H6Q24C	BB - 3	BB - 3	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 12:36:50.36+00	2026-08-04 22:55:53.159+00	2026-08-04 22:55:53.159+00	\N
variant_01KZ6CDN04JWEE795DHJ87QRGN	BB - 4	BB - 4	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 12:36:50.36+00	2026-08-04 22:55:56.944+00	2026-08-04 22:55:56.944+00	\N
variant_01KZ6CDN0A1J78JE24FNSHS9MP	Tennis - green	Tennis - green	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-04 12:36:50.36+00	2026-08-05 12:16:54.804+00	2026-08-05 12:16:54.802+00	\N
variant_01KZ6CDN0CNB01K7EM7DYTT4W1	Tennis - black	Tennis - black	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-04 12:36:50.36+00	2026-08-05 12:16:59.944+00	2026-08-05 12:16:59.943+00	\N
variant_01KZ6CDN0CJPXQCXXEMK1XFRF6	Tennis - white	Tennis - white	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-04 12:36:50.36+00	2026-08-05 12:17:04.347+00	2026-08-05 12:17:04.346+00	\N
variant_01KZ6CDN0DM8BQHYG8E8MC247Z	Tennis - red	Tennis - red	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-04 12:36:50.36+00	2026-08-05 12:17:08.896+00	2026-08-05 12:17:08.895+00	\N
variant_01KZ6CDN10MFHBEXVW9AY6VNR5	Opposites Attract-1	Opposites Attract-1	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYW57VVJNPN63K17BJQ	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN10FS3M9J9R458KWWCY	Opposites Attract-1-back-ring-6	Opposites Attract-1-back-ring-6	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYW57VVJNPN63K17BJQ	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN11N3RJQ1JT3HZHJB6M	Pearl Clasp	Pearl Clasp	\N	\N	\N	f	t	\N	\N	\N	\N	400	\N	\N	\N	\N	0	prod_01KZ6CDKYW6JVJ0M6CJ2BV4CHJ	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN12X6C5ZXKAJYYKTCJW	Pearl Dots	Pearl Dots	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYXXTR7F86BCCC30ZR7	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN14PAMTTK9ZN17X6GGV	Pearly	Pearly	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYX8WKS0VK0PA1MEV6X	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN157SKJYEH6ERS49ABE	ATME - Rose Gold	ATME - Rose Gold	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYY4A5TBFR2ETW7PBKE	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN16SGFVCT0QN1REEEJ7	ATME - Gold	ATME - Gold	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYY4A5TBFR2ETW7PBKE	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1653VPJPTDBG2692C8	ATMB - Rose Gold	ATMB - Rose Gold	\N	\N	\N	f	t	\N	\N	\N	\N	300	\N	\N	\N	\N	0	prod_01KZ6CDKYY274F77R2WV1ZVGCH	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN176X8S73ZRW2Q6VP5P	ATMB - Gold	ATMB - Gold	\N	\N	\N	f	t	\N	\N	\N	\N	300	\N	\N	\N	\N	0	prod_01KZ6CDKYY274F77R2WV1ZVGCH	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN17CPP3GM4KQWGWQ3C4	QR	QR	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYY82VSC9VRBD393XVG	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN18H77W1452A6589BJJ	S Ring	S Ring	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYYSXAKPSQNKY2A7W55	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN18EW24EBYQJ10H2AY4	sakura	sakura	\N	\N	\N	f	t	\N	\N	\N	\N	100	\N	\N	\N	\N	0	prod_01KZ6CDKYYR42B0PEP10Y3FT52	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN195YQVY3WGAXM69NHV	starfish earrings	starfish earrings	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKYZYWXF8070GY5M3PCS	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN195ZKDP2GGW7X31AJT	shapeshifter	shapeshifter	\N	\N	\N	f	t	\N	\N	\N	\N	60	\N	\N	\N	\N	0	prod_01KZ6CDKYZ3M9F6JCNCMYR7E3F	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1A6TK7VP8MD1CSXMF9	Starry Love-1	Starry Love-1	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1A2TZK19NYV9FBRNT0	Starry Love-2	Starry Love-2	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1BJAQE3GNCBGGVF8S9	Starry Love-3	Starry Love-3	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKYZV9Q9AHB9XJ83GZBB	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1BJXMC2W431AWQXD9K	Swirly	Swirly	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ0GNQN22M2K7B7N3SF	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1C58ASFJPESSKWMHWT	Tennis ring - red	Tennis ring - red	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1CVKZAZC7X7Y18B6NG	Tennis ring	Tennis ring	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1DV2KYCS2BTT2Z4WYD	Tennis ring - black	Tennis ring - black	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1DQ2F1143DPJG632WA	Tennis ring - green	Tennis ring - green	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1EDGDPRPCASFEG9CSA	Tennis ring - white	Tennis ring - white	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1ESBDQ21DTWHW7SEAW	Tennis ring - purple	Tennis ring - purple	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ018SVF05RXG350H68	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1EC60T6NRXESHVV206	Thunderstruck	Thunderstruck	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ0H2CPWHX4YDE9MWCM	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1FE0RSH8Y28G9YAHG2	Vechain-green-small	Vechain-green-small	\N	\N	\N	f	t	\N	\N	\N	\N	60	\N	\N	\N	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1F6MKXD4CRQ3GPYK9C	Vechain-green-large	Vechain-green-large	\N	\N	\N	f	t	\N	\N	\N	\N	10	\N	\N	\N	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1G9Z9GA66NY896MWJB	Vechain-white-small	Vechain-white-small	\N	\N	\N	f	t	\N	\N	\N	\N	60	\N	\N	\N	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1G1784T6VDXBQEPWMR	Vechain-white-large	Vechain-white-large	\N	\N	\N	f	t	\N	\N	\N	\N	10	\N	\N	\N	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1H97E8VQCPEJCP8EMZ	Vechain-black-small	Vechain-black-small	\N	\N	\N	f	t	\N	\N	\N	\N	60	\N	\N	\N	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1KKR4BQ649PNPKSRRS	Vechain-black-large	Vechain-black-large	\N	\N	\N	f	t	\N	\N	\N	\N	10	\N	\N	\N	\N	0	prod_01KZ6CDKZ0CYQXJN1TY00CCGAN	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1KVCEACGFHZSMP9ZDM	void	void	\N	\N	\N	f	t	\N	\N	\N	\N	60	\N	\N	\N	\N	0	prod_01KZ6CDKZ0ZYP65PJVX991FY70	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1MS3MSJD2VHRBNE50K	White Set	White Set	\N	\N	\N	f	t	\N	\N	\N	\N	0	\N	\N	\N	\N	0	prod_01KZ6CDKZ1H7XYHWFK0ZRWJZNM	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ6CDN1NZQMAWTPYA4ZYR226	worly	worly	\N	\N	\N	f	t	\N	\N	\N	\N	40	\N	\N	\N	\N	0	prod_01KZ6CDKZ1921PDG5W42Z4XBA6	2026-08-04 12:36:50.366+00	2026-08-04 12:36:50.366+00	\N	\N
variant_01KZ4ZYA0YYCZZNT6W0103RYZ9	Black	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	2026-08-03 23:39:30.209+00	2026-08-04 12:40:32.459+00	2026-08-04 12:40:32.415+00	\N
variant_01KZ4ZYA0ZFFTFZ31Q0C20Y3NB	White	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	prod_01KZ4ZY9GEGSWK1YZHSV7YZ6PW	2026-08-03 23:39:30.211+00	2026-08-04 12:40:32.459+00	2026-08-04 12:40:32.415+00	\N
variant_01KZ6WJVKFR316FW891PNWHVQD	Default variant	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6WJVEFF7CB46ZWSA4QX4NJ	2026-08-04 17:19:18.128+00	2026-08-04 17:19:18.128+00	\N	\N
variant_01KZ6Y4FXAJN1YVKWVK5SSMWA8	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6Y4FTH912SHCT626EJW0XS	2026-08-04 17:46:24.554+00	2026-08-04 17:46:24.554+00	\N	\N
variant_01KZ6CDMZYZPQGK5D855RTKEQN	And Forever - gold	And Forever - gold	\N	\N	\N	t	t	\N	in	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYNFYQ8KEWXD75JHSMR	2026-08-04 12:36:50.359+00	2026-08-04 22:30:11.8+00	\N	\N
variant_01KZ7FWZA010EWS2V928NHNZ7N	BB-G-1	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 22:56:52.544+00	2026-08-04 22:56:52.544+00	\N	\N
variant_01KZ7G009WEW98MFB3QBRNDP4D	BB-G-2	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 22:58:31.869+00	2026-08-04 22:58:31.869+00	\N	\N
variant_01KZ7G0ZKWRSZJQHF6PR6CAYXW	BB-G-3	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 22:59:03.933+00	2026-08-04 22:59:03.933+00	\N	\N
variant_01KZ7G1RFTF7XZBJ3CPQ0Y9ZHJ	BB-G-4	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 22:59:29.402+00	2026-08-04 22:59:29.402+00	\N	\N
variant_01KZ7G2M0XE2YN52YMDD1VCDXE	BB-S-1	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 22:59:57.599+00	2026-08-04 22:59:57.599+00	\N	\N
variant_01KZ7G3DTYYJNWSTGA7SR4TK8F	BB-S-2	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 23:00:24.03+00	2026-08-04 23:00:24.03+00	\N	\N
variant_01KZ7G461AW41JCCGV19F1TSCW	BB-S-3	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 23:00:48.812+00	2026-08-04 23:00:48.812+00	\N	\N
variant_01KZ7G55J7AKM71K2YFG8Z65KM	BB-S-4	\N	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYN61S7DVMW2DEQXG56	2026-08-04 23:01:21.096+00	2026-08-04 23:01:21.096+00	\N	\N
variant_01KZ8Y13W8VX79ZZNZBT53W5R2	Black	Tennis-black	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01KZ6CDKYPDQG0QDKT37MDDPA3	2026-08-05 12:23:02.794+00	2026-08-05 12:23:02.794+00	\N	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01KZ6CDMZYZPQGK5D855RTKEQN	iitem_01KZ6CDN5NZ4RP94G6VXART3VD	pvitem_01KZ6CDNDVVCT9XVZ63AWEPFEC	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDMZYBWZ3RGMVCTK1WV79	iitem_01KZ6CDN5N7VTJQZGQT8HN5GCJ	pvitem_01KZ6CDNDXCT9X9TY10TNSDAQA	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDMZZB1YAKW2PQAZR6KWY	iitem_01KZ6CDN5PCJQ3R6VDXVY58T88	pvitem_01KZ6CDNDZ7ZSDDQQYSF29C6XH	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN058P9B4TRNRBWAQ4MF	iitem_01KZ6CDN5RZ3F70629H3ENNNS1	pvitem_01KZ6CDNE3K9Q8S0CV4FTFZ8ZD	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN06ANBG61KQ092TD09Y	iitem_01KZ6CDN5RZ2R108GNBAEXQRR5	pvitem_01KZ6CDNE4MHFR8FPQ28TWWXA8	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN07A7W4Q0CTB3KVAQVD	iitem_01KZ6CDN5T48SRXRFNZFPJHYYS	pvitem_01KZ6CDNE483TE5CYGYP4B5HT6	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN099BRKMZH8A2C73YF6	iitem_01KZ6CDN5T5AVGH0TFRV1TM50F	pvitem_01KZ6CDNE5YXEH58EWGTXZYWXW	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN09M50P581MG6ZSVJG3	iitem_01KZ6CDN5VF00MTBPJG74FVJET	pvitem_01KZ6CDNE551AJKBFE6FE84BXP	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	iitem_01KZ6CDN5XE4779CCH3VTBP167	pvitem_01KZ6CDNEA0TC28C6E9N5JR9T2	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0EWX32JPFVCY99JTZ0	iitem_01KZ6CDN5XA6JSG53XYSRRC1BX	pvitem_01KZ6CDNEAAAJ8PMFBDQB8RMCD	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0GMBY55W7PG3R0MFJ8	iitem_01KZ6CDN5YKWRCA0GFB9C2PXVH	pvitem_01KZ6CDNEBA9E619ZZN93WQBJ0	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0GQNTK1HFBJ09HS9PC	iitem_01KZ6CDN5YT1WY3TND8KBN2DRV	pvitem_01KZ6CDNEBZ6VSKA11SE8B02MS	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0H6QCATENB9WDW6BEJ	iitem_01KZ6CDN5Z7V2ATWR6NC71W4MG	pvitem_01KZ6CDNEEV1XZPPDJGM7NSY31	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0JPQ4EDYBNDMQ0PN93	iitem_01KZ6CDN5ZCRNP5FVKR02YQT92	pvitem_01KZ6CDNEEHWA0R6HTXZD4YKJS	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0K939YV5FA1MY0ET8V	iitem_01KZ6CDN5ZD7S577FVP4THMQXD	pvitem_01KZ6CDNEF7SRVP6XTFD11XWXM	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0M5W17E3B90MHTWGP1	iitem_01KZ6CDN60QEB5711EFRWR71GP	pvitem_01KZ6CDNEGHHNRS4YTGX2CH574	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	iitem_01KZ6CDN60H6RHAEQ11AJYQ3QY	pvitem_01KZ6CDNEHRT6G6JSFQQFMS029	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	iitem_01KZ6CDN60PPVVBQHCWP3MVY0P	pvitem_01KZ6CDNEJ52KJTWVDHY4XMTCN	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0P9DETBPWK54M1K7AM	iitem_01KZ6CDN61069HRCXTVNWAF4CB	pvitem_01KZ6CDNEKQKQSTPACTYM45PJH	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0Q29QE56892FQQ1MP6	iitem_01KZ6CDN615KKK9N3ZQZMKJJYM	pvitem_01KZ6CDNEME4VNT1R7J1QE8WFS	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0RZDNFJW993VCF7RJ8	iitem_01KZ6CDN62FR8YMXB2FTENJF4Z	pvitem_01KZ6CDNEMAME3ZNNRYQKCJDDA	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0RFPEPFGWN4RW27EZM	iitem_01KZ6CDN6283RMHD7KNE9C89VA	pvitem_01KZ6CDNEPPNRTPWXN7K8KP833	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KYYM133ZHK2BPR0KGJCTFT18	iitem_01KYYM136QQ87RX03C0BFX0F44	pvitem_01KYYM138NNZWFT309SK2X3RD0	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM1340J2REVFW5EWJQZBDG	iitem_01KYYM136QXP4G1YGP4NDRSZPX	pvitem_01KYYM138QM19BNPEH2NMPP7K6	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM134BRDWRDNWCJHSJWPAH	iitem_01KYYM136W7ZVH1VR49X9XYFZC	pvitem_01KYYM138WYWNTH47WPH6HZM8G	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:33.354+00	2026-08-04 17:20:33.353+00
variant_01KYYM134BG6QZAAFWQC3WMVNA	iitem_01KYYM136W4RPAV4R8731DS4QE	pvitem_01KYYM138WJ3APR0A31RMW8EC3	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:33.354+00	2026-08-04 17:20:33.353+00
variant_01KYYM134C8ET3CWTKBBS42QSM	iitem_01KYYM136WFA9S6NXX49NGEZNB	pvitem_01KYYM138WKKSMF2C49V842Z6C	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:33.354+00	2026-08-04 17:20:33.353+00
variant_01KYYM134CFKQZHN8JWQXRHYCS	iitem_01KYYM136WQYJ7VK0SHB0VJQR2	pvitem_01KYYM138X5SM6FNSRH8C3Z2W9	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:33.354+00	2026-08-04 17:20:33.353+00
variant_01KYYM13493XK7BS9PBRXRB5XG	iitem_01KYYM136V5QH1AFKVSNRWZKSC	pvitem_01KYYM138VJVHCR7GB0XXCEV18	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:36.641+00	2026-08-04 17:20:36.641+00
variant_01KYYM13493KRR0HAJ4YTV1852	iitem_01KYYM136VCPV7KGF8B85NBQD7	pvitem_01KYYM138VX14M0WQZSGVC75KK	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:36.641+00	2026-08-04 17:20:36.641+00
variant_01KYYM134AM5ZTADTCSKY5N0P1	iitem_01KYYM136V6TRYDQD3FZQH0B4R	pvitem_01KYYM138VJX2PHWRTM6BNRYAK	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:36.641+00	2026-08-04 17:20:36.641+00
variant_01KYYM134A5BPK0XVMP8SD1NC2	iitem_01KYYM136V4Q07XRGFCEWDF5CV	pvitem_01KYYM138WCFNP5MKRY9NJAF10	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:36.641+00	2026-08-04 17:20:36.641+00
variant_01KYYM1346Q953HWSPSKGB3HWK	iitem_01KYYM136TKZ1BYPK65CV8R83E	pvitem_01KYYM138S7YMQM7WXVP297RQW	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:40.379+00	2026-08-04 17:20:40.378+00
variant_01KYYM13474S1J1ZVMZC66YZ95	iitem_01KYYM136TAZ1WR11AB0DX4T14	pvitem_01KYYM138T6D6DYB1VPR7V2V71	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:40.379+00	2026-08-04 17:20:40.378+00
variant_01KYYM1348EF4TKZA541F1F59G	iitem_01KYYM136TYTEHYNSDGN2BADQ5	pvitem_01KYYM138TZTYS3VJQ6VEDQHA4	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:40.379+00	2026-08-04 17:20:40.378+00
variant_01KYYM1348KMK8ECJ9EVHF6XT5	iitem_01KYYM136V0D05XYGVHBFTKNHN	pvitem_01KYYM138T8M1R9S98465KMBB1	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:40.379+00	2026-08-04 17:20:40.378+00
variant_01KZ6CDN00E12E60Q3673HEK7V	iitem_01KZ6CDN5PJK4RKC3ZZF3S7Y1H	pvitem_01KZ6CDNE0MKHKDMEP2RB56ZJK	1	2026-08-04 12:36:50.093586+00	2026-08-04 22:55:43.877+00	2026-08-04 22:55:43.874+00
variant_01KZ6CDN0191F12MKM5N7MX34Y	iitem_01KZ6CDN5PE1WTZNK2PX9WSCCF	pvitem_01KZ6CDNE1FN4ZBMDCTW3D19F2	1	2026-08-04 12:36:50.093586+00	2026-08-04 22:55:48.613+00	2026-08-04 22:55:48.613+00
variant_01KZ6CDN03DKSN2Q4B94H6Q24C	iitem_01KZ6CDN5QSZFHN38P16VW57KH	pvitem_01KZ6CDNE20WN99EANBCD94E36	1	2026-08-04 12:36:50.093586+00	2026-08-04 22:55:53.042+00	2026-08-04 22:55:53.041+00
variant_01KZ6CDN04JWEE795DHJ87QRGN	iitem_01KZ6CDN5QVH9BQDMJA0361JH2	pvitem_01KZ6CDNE2GPCSZSPTXEJ7DBWP	1	2026-08-04 12:36:50.093586+00	2026-08-04 22:55:56.819+00	2026-08-04 22:55:56.818+00
variant_01KZ6CDN0A1J78JE24FNSHS9MP	iitem_01KZ6CDN5VCQD47QDYTFCMDW8A	pvitem_01KZ6CDNE7T16CY0CNR0DKA9X1	1	2026-08-04 12:36:50.093586+00	2026-08-05 12:16:54.441+00	2026-08-05 12:16:54.439+00
variant_01KZ6CDN0CNB01K7EM7DYTT4W1	iitem_01KZ6CDN5VXHC2R9PC6YY5RDYD	pvitem_01KZ6CDNE8BFJDY9DT2MD62Z7M	1	2026-08-04 12:36:50.093586+00	2026-08-05 12:16:59.608+00	2026-08-05 12:16:59.606+00
variant_01KZ6CDN0CJPXQCXXEMK1XFRF6	iitem_01KZ6CDN5WT51ZVJFZBG58RC97	pvitem_01KZ6CDNE8VV25NVPZ7615DWW9	1	2026-08-04 12:36:50.093586+00	2026-08-05 12:17:04.044+00	2026-08-05 12:17:04.043+00
variant_01KZ6CDN0DM8BQHYG8E8MC247Z	iitem_01KZ6CDN5WRTT34N4XYM5FR0RA	pvitem_01KZ6CDNE9T7NVW1405AXCG055	1	2026-08-04 12:36:50.093586+00	2026-08-05 12:17:08.473+00	2026-08-05 12:17:08.471+00
variant_01KZ6CDN0SBFFRP1A7S1D6Y351	iitem_01KZ6CDN63MFT9B4JTV616EG5F	pvitem_01KZ6CDNEPSAXNFC1NKQWNE9FQ	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0TFW3DJNQV7M0691K9	iitem_01KZ6CDN63A9XT9E79MRB91SAM	pvitem_01KZ6CDNEQ1B2V85BJ92MTSBQA	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0VQNKDJW120N0QSQM7	iitem_01KZ6CDN63AV8G39S081KFVX9D	pvitem_01KZ6CDNESMV5XS3HXYZFHSPNF	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0VW3RPYF9QWCMH80WJ	iitem_01KZ6CDN64TWKHS6WDEYAF4QTB	pvitem_01KZ6CDNESJJDPWMM5KMVNVB38	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0W0VPNG6BG2Z3EPVZ7	iitem_01KZ6CDN649FDE6TE4N7A1Y074	pvitem_01KZ6CDNETZXHAFEPBCER36RKZ	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0WVX41RE2H9B3Q197Q	iitem_01KZ6CDN64RJ4V4T4TZMHAKTGQ	pvitem_01KZ6CDNEVA0A0DBXCJ7NF3M59	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0WGKN5TNBCHB5WDGGH	iitem_01KZ6CDN65V0K81YE2ZVMX6Y76	pvitem_01KZ6CDNEV2EZ3Z7BRJ43T0GJB	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0XWXNPZR007HQYRX3M	iitem_01KZ6CDN65HAJ30WJAFZZJ2CPE	pvitem_01KZ6CDNEWV8K8DNQYT7FA6S2X	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0XWWWH64PC687DE3Z1	iitem_01KZ6CDN652RDPFRG4ATTY1XKF	pvitem_01KZ6CDNEX2B9ZFX8S9KTBM4VH	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0YQWTYZPRG4PHWJ9YS	iitem_01KZ6CDN66N70BQGFM84VV4E07	pvitem_01KZ6CDNEZYZDVZRS02AXQ1SPW	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0Y0JRBHYMN7FCK2C3E	iitem_01KZ6CDN66HPZGE07GAVA3VDDN	pvitem_01KZ6CDNF0HD345D9X8NYQMV3F	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0Z1W5V4F1EN8ZADXEZ	iitem_01KZ6CDN67KPHWXS9TETP0493J	pvitem_01KZ6CDNF1BR5TRFN5DJZFZ4AQ	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN0ZJCMTNHW5GWXNHKST	iitem_01KZ6CDN67K3YE2RXQ3W5EVTWV	pvitem_01KZ6CDNF1YXP7DE8TDG5TN8XD	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN10MFHBEXVW9AY6VNR5	iitem_01KZ6CDN678N5NH3454BPXXR4J	pvitem_01KZ6CDNF2M9CM81X29ZG5DJD5	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN10FS3M9J9R458KWWCY	iitem_01KZ6CDN68X63NB96MEDWMX232	pvitem_01KZ6CDNF3RH9MMVVWX5S7FBVF	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN11N3RJQ1JT3HZHJB6M	iitem_01KZ6CDN686DQ6XV5DCV7D6G6K	pvitem_01KZ6CDNF48XQ36FSBZHZRZ9XG	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN12X6C5ZXKAJYYKTCJW	iitem_01KZ6CDN690GYKMBK4XD9VXR3K	pvitem_01KZ6CDNF4BS6PK7YSEP3RBXMG	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN14PAMTTK9ZN17X6GGV	iitem_01KZ6CDN69NZEGMA6SZKTY5QA7	pvitem_01KZ6CDNF5PK0R9YK9EZ8TF54P	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN157SKJYEH6ERS49ABE	iitem_01KZ6CDN69VCX4A47ZW81M9FT8	pvitem_01KZ6CDNF7W2A2FG3RA8SHGDC1	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN16SGFVCT0QN1REEEJ7	iitem_01KZ6CDN6AXE8PAD3D0BF2RDQ9	pvitem_01KZ6CDNF7NDGFSJSVHZXAVNAW	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1653VPJPTDBG2692C8	iitem_01KZ6CDN6A3JSQ7S5Y19D8KA9M	pvitem_01KZ6CDNF8HP78NCSPJRQF8M25	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN176X8S73ZRW2Q6VP5P	iitem_01KZ6CDN6A4SQHE6E4X8ASSPK7	pvitem_01KZ6CDNF9JVTXTFHFDNJD4W94	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN17CPP3GM4KQWGWQ3C4	iitem_01KZ6CDN6BEY5VF0NE5NMVVQJN	pvitem_01KZ6CDNFA8XQCSMJNNR8Y93CB	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN18H77W1452A6589BJJ	iitem_01KZ6CDN6CP3466X3XKBW3CF9T	pvitem_01KZ6CDNFAS39T874JWJ365S68	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN18EW24EBYQJ10H2AY4	iitem_01KZ6CDN6CC0CMJWAP87Y7NM7P	pvitem_01KZ6CDNFBZ5C68E10YQTQ5Y9S	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN195YQVY3WGAXM69NHV	iitem_01KZ6CDN6CHSTK44VXE0QDS9TB	pvitem_01KZ6CDNFDQK2HMVXA9ADHSXRD	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN195ZKDP2GGW7X31AJT	iitem_01KZ6CDN6DBGCSWVG6D4E0QQV2	pvitem_01KZ6CDNFFQ54PZZR3H1XBK1KD	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1A6TK7VP8MD1CSXMF9	iitem_01KZ6CDN6E30KYG04SGS2AY5XR	pvitem_01KZ6CDNFGNP3XTKTEH9X3TPHE	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1A2TZK19NYV9FBRNT0	iitem_01KZ6CDN6E5GH4KVSHPJ1F4R5Q	pvitem_01KZ6CDNFKXCW8MGT5XJBTM38Y	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1BJAQE3GNCBGGVF8S9	iitem_01KZ6CDN6FT6SCFEJ0J81G979P	pvitem_01KZ6CDNFMC4GAPRWD46B42GFD	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1BJXMC2W431AWQXD9K	iitem_01KZ6CDN6G1E5TRAZ2FZEX0BDJ	pvitem_01KZ6CDNFNV0GFEHBWAA879AGA	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1C58ASFJPESSKWMHWT	iitem_01KZ6CDN6GX8HJS32MAN9WW0K3	pvitem_01KZ6CDNFPZYHH2MCZKPQMSY5H	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1CVKZAZC7X7Y18B6NG	iitem_01KZ6CDN6H2GJS2ZDGAW7Y7F4N	pvitem_01KZ6CDNGY0CAYP5AW1QV1AEJ9	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1DV2KYCS2BTT2Z4WYD	iitem_01KZ6CDN6HWXJ6A69W1GM91WTH	pvitem_01KZ6CDNGY6JKB60B3MK7THKF2	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1DQ2F1143DPJG632WA	iitem_01KZ6CDN6JXAS1V602ZGW42RH3	pvitem_01KZ6CDNGZ6BM4ZQ4M1ZZP8XQN	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1EDGDPRPCASFEG9CSA	iitem_01KZ6CDN6KGJSXZGAB0PXVZ4C3	pvitem_01KZ6CDNH0S4ARJJZJ57F7T71V	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1ESBDQ21DTWHW7SEAW	iitem_01KZ6CDN6KTA6906X7TCHGS98P	pvitem_01KZ6CDNH0Y9WJM8BAKVP3KESA	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1EC60T6NRXESHVV206	iitem_01KZ6CDN6K8TX8AHJHYMJS0CPV	pvitem_01KZ6CDNH0MXH7VTJYBAQRRHGN	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1FE0RSH8Y28G9YAHG2	iitem_01KZ6CDN6M5MPETGA373YC0MRX	pvitem_01KZ6CDNH1PV881ZJ8YFPRGF1F	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1F6MKXD4CRQ3GPYK9C	iitem_01KZ6CDN6N8WK2607W74V9SY3M	pvitem_01KZ6CDNH2313W7Q7FGZPFEJXV	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1G9Z9GA66NY896MWJB	iitem_01KZ6CDN6NBQQ9JVQX37G6YWMP	pvitem_01KZ6CDNH2TA1N7JDYXGH8AYFF	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1G1784T6VDXBQEPWMR	iitem_01KZ6CDN6N341JCXTY8Y5DN5AA	pvitem_01KZ6CDNH2RYV7Q6AKMJ5B4AZ3	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1H97E8VQCPEJCP8EMZ	iitem_01KZ6CDN6P88M5M2TFPS8KBXN3	pvitem_01KZ6CDNH3PXR9WBJVCWDXTEJA	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1KKR4BQ649PNPKSRRS	iitem_01KZ6CDN6QR9X8D7Q48HEKPMYT	pvitem_01KZ6CDNH49H9VH9NTTBV3Z2ZP	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1KVCEACGFHZSMP9ZDM	iitem_01KZ6CDN6QBT9TB5WSPYA8BBYB	pvitem_01KZ6CDNH4E6BZ6Z8XHPX32416	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1MS3MSJD2VHRBNE50K	iitem_01KZ6CDN6QV893HRZQNNAMEH3V	pvitem_01KZ6CDNH4WJ2EWC56B677CF60	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ6CDN1NZQMAWTPYA4ZYR226	iitem_01KZ6CDN6RDQZM2H5KGCFW91G2	pvitem_01KZ6CDNH5RAN4M7XJWN59JTAG	1	2026-08-04 12:36:50.093586+00	2026-08-04 12:36:50.093586+00	\N
variant_01KZ4ZYA0YYCZZNT6W0103RYZ9	iitem_01KZ4ZYA48XDK3Y3WBS95Q9QRA	pvitem_01KZ4ZYA7VRHJ7BN4AEJ00MPJ9	1	2026-08-03 23:39:30.225175+00	2026-08-04 12:40:32.313+00	2026-08-04 12:40:32.312+00
variant_01KZ4ZYA0ZFFTFZ31Q0C20Y3NB	iitem_01KZ4ZYA4AC9CT7BGHE6NKK7S5	pvitem_01KZ4ZYA7Y19Z1VD3K4R18FEXY	1	2026-08-03 23:39:30.225175+00	2026-08-04 12:40:32.313+00	2026-08-04 12:40:32.312+00
variant_01KZ6WJVKFR316FW891PNWHVQD	iitem_01KZ6WJVMFGFYQ68690CJ992QM	pvitem_01KZ6WJVNH281ARWDG0Q1EQM48	1	2026-08-04 17:19:18.213911+00	2026-08-04 17:19:18.213911+00	\N
variant_01KYYM1341B5044GXK40CJMJWS	iitem_01KYYM136RTRKXGXNV5EV0AE7M	pvitem_01KYYM138Q7H7C63MFC7T2DM1X	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM134234VY30GKJKYR1XXD	iitem_01KYYM136RN5D71W3Q8NBVHMWT	pvitem_01KYYM138RMZEMDYNRBA65C8SJ	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM1343PRJJH61TXGN2HFN9	iitem_01KYYM136R96R9Z34605ZDCJ46	pvitem_01KYYM138RBN7TEX9MQ0DF4DZ9	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM1344YXSMB3Z9PJ1RD690	iitem_01KYYM136SQNDX3D363SXAMHW4	pvitem_01KYYM138RQ46XK3CNYEMA8M3X	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM1344NRBNDRH7CHJEMNG1	iitem_01KYYM136STEN57Y417VF8VH3V	pvitem_01KYYM138SJJTNZEGWH1V94PTB	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KYYM1345FZGQVZ3RPRD4PDWY	iitem_01KYYM136SBAV52Q6FQWZZ9GEZ	pvitem_01KYYM138SR1237A3F0D8FE8DA	1	2026-08-01 12:15:52.134793+00	2026-08-04 17:20:30.49+00	2026-08-04 17:20:30.489+00
variant_01KZ7FWZA010EWS2V928NHNZ7N	iitem_01KZ7FWZB3NETWQZJ5DRQCC0XB	pvitem_01KZ7FWZCB1CJ8B3Z14K8728G3	1	2026-08-04 22:56:52.537394+00	2026-08-04 22:56:52.537394+00	\N
variant_01KZ7G009WEW98MFB3QBRNDP4D	iitem_01KZ7G00AYXZY3A9SFWKJXYGVE	pvitem_01KZ7G00BSPCVGGSWVJ9RYJPSQ	1	2026-08-04 22:58:31.931159+00	2026-08-04 22:58:31.931159+00	\N
variant_01KZ7G0ZKWRSZJQHF6PR6CAYXW	iitem_01KZ7G0ZMP840KG6CMMP2JZQX1	pvitem_01KZ7G0ZNEGCX11HPD47E4G206	1	2026-08-04 22:59:04.000233+00	2026-08-04 22:59:04.000233+00	\N
variant_01KZ7G1RFTF7XZBJ3CPQ0Y9ZHJ	iitem_01KZ7G1RGKHQGRWJ4ZEYXZTD13	pvitem_01KZ7G1RHAM5XW0ZFMS58C25NP	1	2026-08-04 22:59:29.455372+00	2026-08-04 22:59:29.455372+00	\N
variant_01KZ7G2M0XE2YN52YMDD1VCDXE	iitem_01KZ7G2M1PDN3MGXQWY609SCDK	pvitem_01KZ7G2M2BWP45CDV8CXCR4GKT	1	2026-08-04 22:59:57.34792+00	2026-08-04 22:59:57.34792+00	\N
variant_01KZ7G3DTYYJNWSTGA7SR4TK8F	iitem_01KZ7G3DVNR1D6E8AY4YEM147T	pvitem_01KZ7G3DWDMG3RD5NZ1KSXNYS8	1	2026-08-04 23:00:24.018952+00	2026-08-04 23:00:24.018952+00	\N
variant_01KZ7G461AW41JCCGV19F1TSCW	iitem_01KZ7G462FDM5XSQQ94N5314NG	pvitem_01KZ7G463C1VPFQS15FQMCKRKQ	1	2026-08-04 23:00:48.838343+00	2026-08-04 23:00:48.838343+00	\N
variant_01KZ7G55J7AKM71K2YFG8Z65KM	iitem_01KZ7G55KCH4M55FDZA76H7AWD	pvitem_01KZ7G55MMQX1TZXNBK417DHH4	1	2026-08-04 23:01:21.121061+00	2026-08-04 23:01:21.121061+00	\N
variant_01KZ8XR8CFJK8BSJGYD2793PY1	iitem_01KZ8XR8G4J1TY7WSNFV5JYVM0	pvitem_01KZ8XR8JY0BQSTQ2XAFW545SY	1	2026-08-05 12:18:12.750205+00	2026-08-05 12:18:12.750205+00	\N
variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	iitem_01KZ8XZHFZANFHV66HRCANNA2H	pvitem_01KZ8XZHKEWK6B56SSQ43WXAWF	1	2026-08-05 12:22:11.323263+00	2026-08-05 12:22:11.323263+00	\N
variant_01KZ8Y13W8VX79ZZNZBT53W5R2	iitem_01KZ8Y13Z8RZEDQ3DPDTNB0J2H	pvitem_01KZ8Y142GR2H9MG95Q56B80H6	1	2026-08-05 12:23:02.964988+00	2026-08-05 12:23:02.964988+00	\N
variant_01KZ8Y1YJ5B7B01RA7EPJYV4S9	iitem_01KZ8Y1YPRMR5588756CNRZY2A	pvitem_01KZ8Y1YTGN2EHN2XQH711VAGJ	1	2026-08-05 12:23:30.368307+00	2026-08-05 12:23:30.368307+00	\N
variant_01KZ8Y2P3AG1XR85T301TYPVND	iitem_01KZ8Y2P89AS3HXGKR1YSQYVE9	pvitem_01KZ8Y2PCCGKY7YWYEFG9WRB0W	1	2026-08-05 12:23:54.49647+00	2026-08-05 12:23:54.49647+00	\N
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01KYYM133ZHK2BPR0KGJCTFT18	optval_01KYYM12E0DHAHVYGXWQ57V8JX
variant_01KYYM133ZHK2BPR0KGJCTFT18	optval_01KYYM12E4GF1KEEG6W45YHNTG
variant_01KYYM1340J2REVFW5EWJQZBDG	optval_01KYYM12E0DHAHVYGXWQ57V8JX
variant_01KYYM1340J2REVFW5EWJQZBDG	optval_01KYYM12E5GP466XZ56SDNBEHC
variant_01KYYM1341B5044GXK40CJMJWS	optval_01KYYM12E1W92RPVQ879TJWH0G
variant_01KYYM1341B5044GXK40CJMJWS	optval_01KYYM12E4GF1KEEG6W45YHNTG
variant_01KYYM134234VY30GKJKYR1XXD	optval_01KYYM12E1W92RPVQ879TJWH0G
variant_01KYYM134234VY30GKJKYR1XXD	optval_01KYYM12E5GP466XZ56SDNBEHC
variant_01KYYM1343PRJJH61TXGN2HFN9	optval_01KYYM12E1AWWQJ28K70F972FQ
variant_01KYYM1343PRJJH61TXGN2HFN9	optval_01KYYM12E4GF1KEEG6W45YHNTG
variant_01KYYM1344YXSMB3Z9PJ1RD690	optval_01KYYM12E1AWWQJ28K70F972FQ
variant_01KYYM1344YXSMB3Z9PJ1RD690	optval_01KYYM12E5GP466XZ56SDNBEHC
variant_01KYYM1344NRBNDRH7CHJEMNG1	optval_01KYYM12E2MGPF8547CKSXC4NE
variant_01KYYM1344NRBNDRH7CHJEMNG1	optval_01KYYM12E4GF1KEEG6W45YHNTG
variant_01KYYM1345FZGQVZ3RPRD4PDWY	optval_01KYYM12E2MGPF8547CKSXC4NE
variant_01KYYM1345FZGQVZ3RPRD4PDWY	optval_01KYYM12E5GP466XZ56SDNBEHC
variant_01KYYM1346Q953HWSPSKGB3HWK	optval_01KYYM12E0DHAHVYGXWQ57V8JX
variant_01KYYM13474S1J1ZVMZC66YZ95	optval_01KYYM12E1W92RPVQ879TJWH0G
variant_01KYYM1348EF4TKZA541F1F59G	optval_01KYYM12E1AWWQJ28K70F972FQ
variant_01KYYM1348KMK8ECJ9EVHF6XT5	optval_01KYYM12E2MGPF8547CKSXC4NE
variant_01KYYM13493XK7BS9PBRXRB5XG	optval_01KYYM12E0DHAHVYGXWQ57V8JX
variant_01KYYM13493KRR0HAJ4YTV1852	optval_01KYYM12E1W92RPVQ879TJWH0G
variant_01KYYM134AM5ZTADTCSKY5N0P1	optval_01KYYM12E1AWWQJ28K70F972FQ
variant_01KYYM134A5BPK0XVMP8SD1NC2	optval_01KYYM12E2MGPF8547CKSXC4NE
variant_01KYYM134BRDWRDNWCJHSJWPAH	optval_01KYYM12E0DHAHVYGXWQ57V8JX
variant_01KYYM134BG6QZAAFWQC3WMVNA	optval_01KYYM12E1W92RPVQ879TJWH0G
variant_01KYYM134C8ET3CWTKBBS42QSM	optval_01KYYM12E1AWWQJ28K70F972FQ
variant_01KYYM134CFKQZHN8JWQXRHYCS	optval_01KYYM12E2MGPF8547CKSXC4NE
variant_01KZ4ZYA0YYCZZNT6W0103RYZ9	optval_01KYYM12E4GF1KEEG6W45YHNTG
variant_01KZ4ZYA0ZFFTFZ31Q0C20Y3NB	optval_01KYYM12E5GP466XZ56SDNBEHC
variant_01KZ6CDMZYZPQGK5D855RTKEQN	optval_01KZ6CDM3W28KJ5CB2T0Q3BCKW
variant_01KZ6CDMZYBWZ3RGMVCTK1WV79	optval_01KZ6CDM3WA5C0ZZVYV28RPJEA
variant_01KZ6CDMZZB1YAKW2PQAZR6KWY	optval_01KZ6CDM3YMXP8T2A8SZ31TPDK
variant_01KZ6CDN00E12E60Q3673HEK7V	optval_01KZ6CDM41S19P5YJCJTN4T41Z
variant_01KZ6CDN00E12E60Q3673HEK7V	optval_01KZ6CDM42D7N5AVJ6BJAAKERC
variant_01KZ6CDN0191F12MKM5N7MX34Y	optval_01KZ6CDM41S19P5YJCJTN4T41Z
variant_01KZ6CDN0191F12MKM5N7MX34Y	optval_01KZ6CDM43ASG18CPQTFTH3Q5N
variant_01KZ6CDN03DKSN2Q4B94H6Q24C	optval_01KZ6CDM41S19P5YJCJTN4T41Z
variant_01KZ6CDN03DKSN2Q4B94H6Q24C	optval_01KZ6CDM43J6E75PPM9T0EG699
variant_01KZ6CDN04JWEE795DHJ87QRGN	optval_01KZ6CDM41S19P5YJCJTN4T41Z
variant_01KZ6CDN04JWEE795DHJ87QRGN	optval_01KZ6CDM44GRFAT1NQ41WSA4BJ
variant_01KZ6CDN058P9B4TRNRBWAQ4MF	optval_01KZ6CDM45DKVND48S0VJFCD4C
variant_01KZ6CDN06ANBG61KQ092TD09Y	optval_01KZ6CDM459HTNZH620ZMQ9VZM
variant_01KZ6CDN07A7W4Q0CTB3KVAQVD	optval_01KZ6CDM46H3SJ8EXB2TM37Y1Z
variant_01KZ6CDN099BRKMZH8A2C73YF6	optval_01KZ6CDM47YHXC0Y2KCWDW9RE8
variant_01KZ6CDN09M50P581MG6ZSVJG3	optval_01KZ6CDM4806NTDY0K716PT6JC
variant_01KZ6CDN0A1J78JE24FNSHS9MP	optval_01KZ6CDM4A4SNJ4G989694M922
variant_01KZ6CDN0CNB01K7EM7DYTT4W1	optval_01KZ6CDM4AK3VVD80RJ6HB6FGJ
variant_01KZ6CDN0CJPXQCXXEMK1XFRF6	optval_01KZ6CDM4A4ND4SB82G4RPDEAY
variant_01KZ6CDN0DM8BQHYG8E8MC247Z	optval_01KZ6CDM4B9EKN61690DEGB4AX
variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	optval_01KZ6CDM4CH9DQDJ36KV9DGPZ0
variant_01KZ6CDN0EWX32JPFVCY99JTZ0	optval_01KZ6CDM4D9BR267Y0S53NANB1
variant_01KZ6CDN0GMBY55W7PG3R0MFJ8	optval_01KZ6CDM4ESR6SQC81NSQMFSDV
variant_01KZ6CDN0GQNTK1HFBJ09HS9PC	optval_01KZ6CDM4F7JCPS0WXYR7ZQNHW
variant_01KZ6CDN0H6QCATENB9WDW6BEJ	optval_01KZ6CDM4GQ7C3FSST8AGX7EMN
variant_01KZ6CDN0JPQ4EDYBNDMQ0PN93	optval_01KZ6CDM4HT9PXV9Y61ST3WXN2
variant_01KZ6CDN0K939YV5FA1MY0ET8V	optval_01KZ6CDM4H3FF7B0EK7VC9RED1
variant_01KZ6CDN0M5W17E3B90MHTWGP1	optval_01KZ6CDM4J2GXRC50795KEHCTY
variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	optval_01KZ6CDM4J0H92EG4BSNWSYCZJ
variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	optval_01KZ6CDM4KE4PYQ1VGVGXCWW3R
variant_01KZ6CDN0P9DETBPWK54M1K7AM	optval_01KZ6CDM4KBMEW60CV3B53DZ4T
variant_01KZ6CDN0Q29QE56892FQQ1MP6	optval_01KZ6CDM4MDTND9CJS3A4ARX7M
variant_01KZ6CDN0RZDNFJW993VCF7RJ8	optval_01KZ6CDM4NSE2R3T1GKK930K67
variant_01KZ6CDN0RFPEPFGWN4RW27EZM	optval_01KZ6CDM4N0W6KD19HYCJK05ZH
variant_01KZ6CDN0SBFFRP1A7S1D6Y351	optval_01KZ6CDM4PNS7JB9J5AFGW8HT3
variant_01KZ6CDN0TFW3DJNQV7M0691K9	optval_01KZ6CDM4PWJXTJ8XSE8X3329H
variant_01KZ6CDN0VQNKDJW120N0QSQM7	optval_01KZ6CDM4QJ8Q6AQ43FAV5MV5Q
variant_01KZ6CDN0VW3RPYF9QWCMH80WJ	optval_01KZ6CDM4RRX2F5CDDC7BMF2KA
variant_01KZ6CDN0W0VPNG6BG2Z3EPVZ7	optval_01KZ6CDM4S8Y24SK7KAHGHE90B
variant_01KZ6CDN0WVX41RE2H9B3Q197Q	optval_01KZ6CDM4T72AGF4W020M8R65X
variant_01KZ6CDN0WGKN5TNBCHB5WDGGH	optval_01KZ6CDM4VCTKCSP46YYJ99ZAQ
variant_01KZ6CDN0XWXNPZR007HQYRX3M	optval_01KZ6CDM4WX0JF3DHJ9MNC6MVD
variant_01KZ6CDN0XWWWH64PC687DE3Z1	optval_01KZ6CDM4XZ043QC52ZSTC8PQJ
variant_01KZ6CDN0YQWTYZPRG4PHWJ9YS	optval_01KZ6CDM4X1G0SDBNBW728YVP6
variant_01KZ6CDN0Y0JRBHYMN7FCK2C3E	optval_01KZ6CDM4YFDTPR41VK295CWW3
variant_01KZ6CDN0Z1W5V4F1EN8ZADXEZ	optval_01KZ6CDM4Z5TCNE79VCX1T4VC1
variant_01KZ6CDN0ZJCMTNHW5GWXNHKST	optval_01KZ6CDM500W1GD1H173X7WT5H
variant_01KZ6CDN10MFHBEXVW9AY6VNR5	optval_01KZ6CDM51ZJ3ZMR8CSKTRG04C
variant_01KZ6CDN10MFHBEXVW9AY6VNR5	optval_01KZ6CDM539S56WJKSMMZQZ8QG
variant_01KZ6CDN10FS3M9J9R458KWWCY	optval_01KZ6CDM529NBZS3KY4G2CFGAG
variant_01KZ6CDN10FS3M9J9R458KWWCY	optval_01KZ6CDM539S56WJKSMMZQZ8QG
variant_01KZ6CDN11N3RJQ1JT3HZHJB6M	optval_01KZ6CDM54EGVN6P7KGG65NY3M
variant_01KZ6CDN12X6C5ZXKAJYYKTCJW	optval_01KZ6CDM555ZW57TMGB35SKW6Z
variant_01KZ6CDN14PAMTTK9ZN17X6GGV	optval_01KZ6CDM55D828K3FT5XJ6VJW5
variant_01KZ6CDN157SKJYEH6ERS49ABE	optval_01KZ6CDM58F1BTYF0SFZ5469KX
variant_01KZ6CDN16SGFVCT0QN1REEEJ7	optval_01KZ6CDM592MTFBTXW1R2E5M4Y
variant_01KZ6CDN1653VPJPTDBG2692C8	optval_01KZ6CDM594XE5XJ237T3HGGRY
variant_01KZ6CDN176X8S73ZRW2Q6VP5P	optval_01KZ6CDM5AR7G5RXPW84G3BJN7
variant_01KZ6CDN17CPP3GM4KQWGWQ3C4	optval_01KZ6CDM5B14HDBG0V0P3XF2FD
variant_01KZ6CDN18H77W1452A6589BJJ	optval_01KZ6CDM5CSR6K28005PWYFDJ5
variant_01KZ6CDN18EW24EBYQJ10H2AY4	optval_01KZ6CDM5DC2FCCVF2N8BZTFTN
variant_01KZ6CDN195YQVY3WGAXM69NHV	optval_01KZ6CDM5EMWZ98YMGCYZF6X89
variant_01KZ6CDN195ZKDP2GGW7X31AJT	optval_01KZ6CDM5FGP487868D51CQ58Q
variant_01KZ6CDN1A6TK7VP8MD1CSXMF9	optval_01KZ6CDM5GBXK2BKA9DPQBS5S7
variant_01KZ6CDN1A2TZK19NYV9FBRNT0	optval_01KZ6CDM5GV1YHV6RA166SABS9
variant_01KZ6CDN1BJAQE3GNCBGGVF8S9	optval_01KZ6CDM5GA4D497QXKTV8E4D1
variant_01KZ6CDN1BJXMC2W431AWQXD9K	optval_01KZ6CDM5H2JKWTG9SGK6SFX4W
variant_01KZ6CDN1C58ASFJPESSKWMHWT	optval_01KZ6CDM5JCKH1XKEYG8MPC4M3
variant_01KZ6CDN1CVKZAZC7X7Y18B6NG	optval_01KZ6CDM5JJ7HV38ER0YNKAAC8
variant_01KZ6CDN1DV2KYCS2BTT2Z4WYD	optval_01KZ6CDM5KJ6EEB6C8WAAT44VW
variant_01KZ6CDN1DQ2F1143DPJG632WA	optval_01KZ6CDM5KGP3AD6HP38120VQR
variant_01KZ6CDN1EDGDPRPCASFEG9CSA	optval_01KZ6CDM5MKSNY67SWV0N6JS8F
variant_01KZ6CDN1ESBDQ21DTWHW7SEAW	optval_01KZ6CDM5MWVCD58SSWJ47N15Q
variant_01KZ6CDN1EC60T6NRXESHVV206	optval_01KZ6CDM5NBC5861V8TCZ325S2
variant_01KZ6CDN1FE0RSH8Y28G9YAHG2	optval_01KZ6CDM5P208EKYEDECEKWEV4
variant_01KZ6CDN1FE0RSH8Y28G9YAHG2	optval_01KZ6CDM5RXG46W504GMPXN4HZ
variant_01KZ6CDN1F6MKXD4CRQ3GPYK9C	optval_01KZ6CDM5P208EKYEDECEKWEV4
variant_01KZ6CDN1F6MKXD4CRQ3GPYK9C	optval_01KZ6CDM5SW5W8GN7NRJCYPT1H
variant_01KZ6CDN1G9Z9GA66NY896MWJB	optval_01KZ6CDM5Q8QYJ024CJ6P86GYF
variant_01KZ6CDN1G9Z9GA66NY896MWJB	optval_01KZ6CDM5RXG46W504GMPXN4HZ
variant_01KZ6CDN1G1784T6VDXBQEPWMR	optval_01KZ6CDM5Q8QYJ024CJ6P86GYF
variant_01KZ6CDN1G1784T6VDXBQEPWMR	optval_01KZ6CDM5SW5W8GN7NRJCYPT1H
variant_01KZ6CDN1H97E8VQCPEJCP8EMZ	optval_01KZ6CDM5Q21JGJ33QR2MS6SWA
variant_01KZ6CDN1H97E8VQCPEJCP8EMZ	optval_01KZ6CDM5RXG46W504GMPXN4HZ
variant_01KZ6CDN1KKR4BQ649PNPKSRRS	optval_01KZ6CDM5Q21JGJ33QR2MS6SWA
variant_01KZ6CDN1KKR4BQ649PNPKSRRS	optval_01KZ6CDM5SW5W8GN7NRJCYPT1H
variant_01KZ6CDN1KVCEACGFHZSMP9ZDM	optval_01KZ6CDM5SSGKX05JEEZBX67DZ
variant_01KZ6CDN1MS3MSJD2VHRBNE50K	optval_01KZ6CDM5VC3PZMKC1RA13G4Y4
variant_01KZ6CDN1NZQMAWTPYA4ZYR226	optval_01KZ6CDM5WCS72Q798ZPN1EQWD
variant_01KZ6WJVKFR316FW891PNWHVQD	optval_01KZ6WJVEHC52BAJJ7FS9VD4V6
variant_01KZ6Y4FXAJN1YVKWVK5SSMWA8	optval_01KZ6Y4FTKAHXAKPTZSE9YWYBT
variant_01KZ7FWZA010EWS2V928NHNZ7N	optval_01KZ7FSFSG7XREEAF8YA2XBBBY
variant_01KZ7FWZA010EWS2V928NHNZ7N	optval_01KZ6CDM42D7N5AVJ6BJAAKERC
variant_01KZ7G009WEW98MFB3QBRNDP4D	optval_01KZ6CDM43ASG18CPQTFTH3Q5N
variant_01KZ7G009WEW98MFB3QBRNDP4D	optval_01KZ7FSFSG7XREEAF8YA2XBBBY
variant_01KZ7G0ZKWRSZJQHF6PR6CAYXW	optval_01KZ6CDM43J6E75PPM9T0EG699
variant_01KZ7G0ZKWRSZJQHF6PR6CAYXW	optval_01KZ7FSFSG7XREEAF8YA2XBBBY
variant_01KZ7G1RFTF7XZBJ3CPQ0Y9ZHJ	optval_01KZ6CDM44GRFAT1NQ41WSA4BJ
variant_01KZ7G1RFTF7XZBJ3CPQ0Y9ZHJ	optval_01KZ7FSFSG7XREEAF8YA2XBBBY
variant_01KZ7G2M0XE2YN52YMDD1VCDXE	optval_01KZ6CDM42D7N5AVJ6BJAAKERC
variant_01KZ7G2M0XE2YN52YMDD1VCDXE	optval_01KZ75Q2FSFKVX3NZ33F2QEMXE
variant_01KZ7G3DTYYJNWSTGA7SR4TK8F	optval_01KZ6CDM43ASG18CPQTFTH3Q5N
variant_01KZ7G3DTYYJNWSTGA7SR4TK8F	optval_01KZ75Q2FSFKVX3NZ33F2QEMXE
variant_01KZ7G461AW41JCCGV19F1TSCW	optval_01KZ6CDM43J6E75PPM9T0EG699
variant_01KZ7G461AW41JCCGV19F1TSCW	optval_01KZ75Q2FSFKVX3NZ33F2QEMXE
variant_01KZ7G55J7AKM71K2YFG8Z65KM	optval_01KZ6CDM44GRFAT1NQ41WSA4BJ
variant_01KZ7G55J7AKM71K2YFG8Z65KM	optval_01KZ75Q2FSFKVX3NZ33F2QEMXE
variant_01KZ8XR8CFJK8BSJGYD2793PY1	optval_01KZ75Q2FWX3TTSHW91BYT2X8P
variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	optval_01KZ75Q2FQQ2XX0TPCDD4FMWQF
variant_01KZ8Y13W8VX79ZZNZBT53W5R2	optval_01KYYM12E4GF1KEEG6W45YHNTG
variant_01KZ8Y1YJ5B7B01RA7EPJYV4S9	optval_01KZ75Q2FVGEQYW0B6QDVEJTE6
variant_01KZ8Y2P3AG1XR85T301TYPVND	optval_01KYYM12E5GP466XZ56SDNBEHC
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01KZ6CDMZYZPQGK5D855RTKEQN	pset_01KZ6CDNKK5MNHWR8400KGPC3P	pvps_01KZ6CDNW22F3WNRX1KMKK3BV9	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDMZYBWZ3RGMVCTK1WV79	pset_01KZ6CDNKMQ5W80136AV6AX19Z	pvps_01KZ6CDNW3QV970XDT8HVC7Z95	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDMZZB1YAKW2PQAZR6KWY	pset_01KZ6CDNKN23R9BC98G8XBA1V0	pvps_01KZ6CDNW425GQXC4NDDM5FEN6	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN058P9B4TRNRBWAQ4MF	pset_01KZ6CDNKSWZR2TSBGZ3GPA0AH	pvps_01KZ6CDNW5E8HKA08PJH83WVAE	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN06ANBG61KQ092TD09Y	pset_01KZ6CDNKTKK34WD04BP2R2Y0M	pvps_01KZ6CDNW6W084B74VAK3R07HJ	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN07A7W4Q0CTB3KVAQVD	pset_01KZ6CDNKV8Y9TZN1YNJ4G4CWB	pvps_01KZ6CDNW7VNTJZDHFBP7R03FT	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN099BRKMZH8A2C73YF6	pset_01KZ6CDNKWXMVWDQXK7TW6C5PM	pvps_01KZ6CDNW71VSGJA91F4B8PW81	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN09M50P581MG6ZSVJG3	pset_01KZ6CDNKX87AAHCP43EJEJQ6T	pvps_01KZ6CDNW8VF9T1XJXNW5FHZ5Q	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	pset_01KZ6CDNM2PYC1WFK74P8B0KE6	pvps_01KZ6CDNWB3J7K56XKZWZ3PV75	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0EWX32JPFVCY99JTZ0	pset_01KZ6CDNM3SJ2DXE9YXY6FYRG0	pvps_01KZ6CDNWB6GB28V5Z6BMN7BJW	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0GMBY55W7PG3R0MFJ8	pset_01KZ6CDNM3ETYSERJ2JCP0ZYHR	pvps_01KZ6CDNWBS96Q3RF57Z2330EX	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0GQNTK1HFBJ09HS9PC	pset_01KZ6CDNM4Q64A2M2XBE3W7Q5D	pvps_01KZ6CDNWCPBGXSN2V839WDE1Y	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0H6QCATENB9WDW6BEJ	pset_01KZ6CDNM57VKQD39962B4YRAH	pvps_01KZ6CDNWD14JAFN0ZWQT3TKKK	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0JPQ4EDYBNDMQ0PN93	pset_01KZ6CDNM66W7NQSJHNH2ECZA2	pvps_01KZ6CDNWEZMYTB63E6M004Y3X	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0K939YV5FA1MY0ET8V	pset_01KZ6CDNM6F6P2BHKM1CG3NYT6	pvps_01KZ6CDNWE26T2QJNCQXQPN6Z4	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0M5W17E3B90MHTWGP1	pset_01KZ6CDNM778PVGESD65Y2TFVJ	pvps_01KZ6CDNWFB5JP337HH5QAW9NR	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	pset_01KZ6CDNM95KKRF23Z0AXJC54E	pvps_01KZ6CDNWF38BQW9WWS5JZAMKV	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	pset_01KZ6CDNMATHEP453YDRFTSG9R	pvps_01KZ6CDNWGQPFTF8TH8WE3PNRE	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0P9DETBPWK54M1K7AM	pset_01KZ6CDNMBWYSES2647Q638K89	pvps_01KZ6CDNWG57KGTRS93JNTH2S6	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0Q29QE56892FQQ1MP6	pset_01KZ6CDNMCW0JPX8R3J5B4DC44	pvps_01KZ6CDNWHCH40J39D57XBP7P2	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0RZDNFJW993VCF7RJ8	pset_01KZ6CDNMD8ZBSXCT3EQRH9PPS	pvps_01KZ6CDNWHYJT6VKFXW2BG48FJ	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0RFPEPFGWN4RW27EZM	pset_01KZ6CDNMEQHDJSXM7TCXTZ5JR	pvps_01KZ6CDNWJDY1B1Y5QKBBDQ68S	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0SBFFRP1A7S1D6Y351	pset_01KZ6CDNMF3JK1EZMB28AVNS22	pvps_01KZ6CDNWJ5JMTXRAPRNC0T2SS	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0TFW3DJNQV7M0691K9	pset_01KZ6CDNMGCWGJVDGKPCJN8WHQ	pvps_01KZ6CDNWKZP884VXHEQPYX6YD	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0VQNKDJW120N0QSQM7	pset_01KZ6CDNMHAZPFCMFVFVK8ND2H	pvps_01KZ6CDNWKREHM9WY1MC4QV07E	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KYYM133ZHK2BPR0KGJCTFT18	pset_01KYYM139ZCKKH87382SWXXM2B	pvps_01KYYM13E6NHRJXQ0S2ST0E53K	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.527+00	2026-08-04 17:20:30.524+00
variant_01KYYM1340J2REVFW5EWJQZBDG	pset_01KYYM13A1DQHD2KTWQPQ8SVEN	pvps_01KYYM13E8B4B6PVKP23YGW2M7	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.527+00	2026-08-04 17:20:30.524+00
variant_01KYYM134BRDWRDNWCJHSJWPAH	pset_01KYYM13AJ4CHK4RCBRVA5JW7T	pvps_01KYYM13EKPECZ1C3392WNZGFS	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:33.384+00	2026-08-04 17:20:33.384+00
variant_01KYYM134BG6QZAAFWQC3WMVNA	pset_01KYYM13AK1M83SRFKDV0EZ92J	pvps_01KYYM13EMMY6S75CBVB1JR1P0	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:33.384+00	2026-08-04 17:20:33.384+00
variant_01KYYM134C8ET3CWTKBBS42QSM	pset_01KYYM13ANWE45PGS6FTAFW891	pvps_01KYYM13EN173B98ESHJ0YDXAX	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:33.384+00	2026-08-04 17:20:33.384+00
variant_01KYYM134CFKQZHN8JWQXRHYCS	pset_01KYYM13AP1VJ8WS9JV8HW5V0Y	pvps_01KYYM13ENSS72GVX6X2Z17TSQ	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:33.384+00	2026-08-04 17:20:33.384+00
variant_01KYYM13493XK7BS9PBRXRB5XG	pset_01KYYM13AEJ76N13RV163E3CYY	pvps_01KYYM13EGKMR8KE1HA07A4T2S	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:36.679+00	2026-08-04 17:20:36.677+00
variant_01KYYM13493KRR0HAJ4YTV1852	pset_01KYYM13AFW7BYET0YK90NT4G5	pvps_01KYYM13EHM2JYSZCP9FTJ2W6A	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:36.679+00	2026-08-04 17:20:36.677+00
variant_01KYYM134AM5ZTADTCSKY5N0P1	pset_01KYYM13AGMZJPNVK2FTCTW0T7	pvps_01KYYM13EJ3R37KS2PAQ01RN7X	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:36.679+00	2026-08-04 17:20:36.677+00
variant_01KYYM134A5BPK0XVMP8SD1NC2	pset_01KYYM13AHVA0F4G30PJQ3ZC8R	pvps_01KYYM13EK6E8WRT0Y9HS75K7Y	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:36.679+00	2026-08-04 17:20:36.677+00
variant_01KYYM1346Q953HWSPSKGB3HWK	pset_01KYYM13AARN1HQA2JFEN5VQTP	pvps_01KYYM13EDED95ZQBW47KG8320	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:40.409+00	2026-08-04 17:20:40.409+00
variant_01KYYM13474S1J1ZVMZC66YZ95	pset_01KYYM13ABACPTPSKXKAFH29K4	pvps_01KYYM13EEZS7FS3DEY69TMBRM	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:40.409+00	2026-08-04 17:20:40.409+00
variant_01KYYM1348EF4TKZA541F1F59G	pset_01KYYM13ACW862P4AFH0NRF18R	pvps_01KYYM13EF8RHRK7QWCTSYMW01	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:40.41+00	2026-08-04 17:20:40.409+00
variant_01KYYM1348KMK8ECJ9EVHF6XT5	pset_01KYYM13ADYCWVZ4GXXSNX25KZ	pvps_01KYYM13EG0SN83GKCV5V5993C	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:40.41+00	2026-08-04 17:20:40.409+00
variant_01KZ6CDN00E12E60Q3673HEK7V	pset_01KZ6CDNKNQK3R2RZ6Z0ZGE5CZ	pvps_01KZ6CDNW40948JH4GBZZJVTK6	2026-08-04 12:36:50.522561+00	2026-08-04 22:55:43.882+00	2026-08-04 22:55:43.881+00
variant_01KZ6CDN0191F12MKM5N7MX34Y	pset_01KZ6CDNKP3M9VPP6T9BBP0NBW	pvps_01KZ6CDNW4WY1X4MFRG847BFP8	2026-08-04 12:36:50.522561+00	2026-08-04 22:55:48.619+00	2026-08-04 22:55:48.618+00
variant_01KZ6CDN03DKSN2Q4B94H6Q24C	pset_01KZ6CDNKQ01CRDP40M8VV0RH1	pvps_01KZ6CDNW5XDPBTZRQ4GWZWTQS	2026-08-04 12:36:50.522561+00	2026-08-04 22:55:53.038+00	2026-08-04 22:55:53.037+00
variant_01KZ6CDN04JWEE795DHJ87QRGN	pset_01KZ6CDNKR9JDVRZGY7N3X8EXB	pvps_01KZ6CDNW54S0DMKV50CJXPYV8	2026-08-04 12:36:50.522561+00	2026-08-04 22:55:56.822+00	2026-08-04 22:55:56.822+00
variant_01KZ6CDN0A1J78JE24FNSHS9MP	pset_01KZ6CDNKYPWF5QVXBMZVZZPMV	pvps_01KZ6CDNW8FGB55D0QBKKXDP4S	2026-08-04 12:36:50.522561+00	2026-08-05 12:16:54.43+00	2026-08-05 12:16:54.428+00
variant_01KZ6CDN0CNB01K7EM7DYTT4W1	pset_01KZ6CDNKZ9G9XRVA00X38W1X1	pvps_01KZ6CDNW9DH8GS2T96EK0SR55	2026-08-04 12:36:50.522561+00	2026-08-05 12:16:59.616+00	2026-08-05 12:16:59.614+00
variant_01KZ6CDN0CJPXQCXXEMK1XFRF6	pset_01KZ6CDNM0BB8YGVCRQCJVVNG4	pvps_01KZ6CDNWAVTFE7ZYDNWQ25EYC	2026-08-04 12:36:50.522561+00	2026-08-05 12:17:04.034+00	2026-08-05 12:17:04.033+00
variant_01KZ6CDN0DM8BQHYG8E8MC247Z	pset_01KZ6CDNM1HH2SXT0A72VEJ5P6	pvps_01KZ6CDNWAA598X1S000GE8WCA	2026-08-04 12:36:50.522561+00	2026-08-05 12:17:08.455+00	2026-08-05 12:17:08.451+00
variant_01KZ6CDN0VW3RPYF9QWCMH80WJ	pset_01KZ6CDNMHWX6ZCV8MN22GGYSR	pvps_01KZ6CDNWMWND1EJXYC1FSG6ZH	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0W0VPNG6BG2Z3EPVZ7	pset_01KZ6CDNMJBZ4NGMJZ1C3Z689M	pvps_01KZ6CDNWMQ0XQQXV74Y021NAN	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0WVX41RE2H9B3Q197Q	pset_01KZ6CDNMKJ4BK5T4M6ZR0BZ2Z	pvps_01KZ6CDNWN2K322CR2DXA1TDS6	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0WGKN5TNBCHB5WDGGH	pset_01KZ6CDNMM80TDKPN2NN3S6HJJ	pvps_01KZ6CDNWNCVDN371EKENY5WQM	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0XWXNPZR007HQYRX3M	pset_01KZ6CDNMNSH5724KCTBQDFGBJ	pvps_01KZ6CDNWPN1Q8NAQ9V0TW924V	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0XWWWH64PC687DE3Z1	pset_01KZ6CDNMPTP460QMTG1AFYKFS	pvps_01KZ6CDNWPJVB5BF6SZ46Y2XZ7	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0YQWTYZPRG4PHWJ9YS	pset_01KZ6CDNMQ6EZ34R9B7JACVWHN	pvps_01KZ6CDNWQ98STTNRRHCNNT42Q	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0Y0JRBHYMN7FCK2C3E	pset_01KZ6CDNMQ7HGG5G3XKEC79Q15	pvps_01KZ6CDNWQ8K5N4STWV8NPAJR9	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0Z1W5V4F1EN8ZADXEZ	pset_01KZ6CDNMR0YMP6C30YHJBQF5B	pvps_01KZ6CDNWRJQV3EFWAVBJJSVZC	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN0ZJCMTNHW5GWXNHKST	pset_01KZ6CDNMSVQW1BR6Q91CYXY2Z	pvps_01KZ6CDNWR62B4DHSR3RF2NWVC	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN10MFHBEXVW9AY6VNR5	pset_01KZ6CDNMTZ967FXA6X3K2XY6V	pvps_01KZ6CDNWS8CC34YGBE28A6WNT	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN10FS3M9J9R458KWWCY	pset_01KZ6CDNMVP7B1BJ1T7XJGM7SR	pvps_01KZ6CDNWSB393DC82N83A6S6A	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN11N3RJQ1JT3HZHJB6M	pset_01KZ6CDNMV8ZSPN02WQ1YYTY89	pvps_01KZ6CDNWTQTN99CMA7SVXHXA1	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN12X6C5ZXKAJYYKTCJW	pset_01KZ6CDNMW4PP8ZMTCMS9QRNBQ	pvps_01KZ6CDNWTTSBWKPKK080TWY0Q	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN14PAMTTK9ZN17X6GGV	pset_01KZ6CDNMY7DXQRMZDF54K55C0	pvps_01KZ6CDNWV56TK3RSGF6N99ZA7	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN157SKJYEH6ERS49ABE	pset_01KZ6CDNMZTTN626A0EV8YNF91	pvps_01KZ6CDNWVJACHBZ1PH06472NQ	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN16SGFVCT0QN1REEEJ7	pset_01KZ6CDNMZ1980NA0T4YFFJAPC	pvps_01KZ6CDNWVN6ZZVSNM4DX16BDJ	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1653VPJPTDBG2692C8	pset_01KZ6CDNN09ZMSWZQGNZK02JVG	pvps_01KZ6CDNWW7H73AXZA4JNZRGNW	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN176X8S73ZRW2Q6VP5P	pset_01KZ6CDNN1SRK5FJZ03M4Y5XT4	pvps_01KZ6CDNWWSQTQQ1M9KT7Y1RQH	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN17CPP3GM4KQWGWQ3C4	pset_01KZ6CDNN2MHWGP8MJEAVAA4NK	pvps_01KZ6CDNWXWCG29HH9B0C77A51	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN18H77W1452A6589BJJ	pset_01KZ6CDNN3VWQE0EHKFDXG5X39	pvps_01KZ6CDNWX2EZ8Q0VJDPAXJ99C	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN18EW24EBYQJ10H2AY4	pset_01KZ6CDNN46J6A1QKYA2T5AM9Z	pvps_01KZ6CDNWYHX8TDA3HTYW2T3FH	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN195YQVY3WGAXM69NHV	pset_01KZ6CDNN4YNHEX63NGCZW6ZJW	pvps_01KZ6CDNWY8GNXNHX7MYZ2RWBW	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN195ZKDP2GGW7X31AJT	pset_01KZ6CDNN519PR8DVNDJ7TYWDE	pvps_01KZ6CDNWZ7BQEAA8YGRC76S3P	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1A6TK7VP8MD1CSXMF9	pset_01KZ6CDNN64KRNBB54GNV1HR9A	pvps_01KZ6CDNWZ1QQZ49B4SGRW4FCD	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1A2TZK19NYV9FBRNT0	pset_01KZ6CDNN7RHX5E7VZ1F5T6614	pvps_01KZ6CDNX06G0B8ESTPSJQRAA4	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1BJAQE3GNCBGGVF8S9	pset_01KZ6CDNN8JEEZWKPA0TANWJKB	pvps_01KZ6CDNX0H6W5WJXH9VRDZFYB	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1BJXMC2W431AWQXD9K	pset_01KZ6CDNN935J5F65YZH79HQQN	pvps_01KZ6CDNX1MKPVGBKNR63YDDHF	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1C58ASFJPESSKWMHWT	pset_01KZ6CDNNAPFEWG2A5HQ3ZDGDJ	pvps_01KZ6CDNX179FC64PZSTT564P3	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1CVKZAZC7X7Y18B6NG	pset_01KZ6CDNNB06XXGS5YGD8500WD	pvps_01KZ6CDNX2Y68N7CQARY075Y7J	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1DV2KYCS2BTT2Z4WYD	pset_01KZ6CDNNCRVGY5Q4RVS5DTSMD	pvps_01KZ6CDNX3XMR3GN58SHCDW5X1	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1DQ2F1143DPJG632WA	pset_01KZ6CDNNE41Y027QW7WMMTHHF	pvps_01KZ6CDNX3WZMDKC58TV3R9HQM	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1EDGDPRPCASFEG9CSA	pset_01KZ6CDNNF7D07TN9080SZ8KXX	pvps_01KZ6CDNX404F1AW2W0B1SQPVS	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1ESBDQ21DTWHW7SEAW	pset_01KZ6CDNNGAX3JD6W9E15Q8XHV	pvps_01KZ6CDNX4BF392RWFVTAG5JDH	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1EC60T6NRXESHVV206	pset_01KZ6CDNNHJ7VZ46S98ZS1TW1Q	pvps_01KZ6CDNX58H23AYGFZRH93WJJ	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1FE0RSH8Y28G9YAHG2	pset_01KZ6CDNNJ5YEMRP3Y067B9ZSQ	pvps_01KZ6CDNX5NBQSVDJEX0SPHSV9	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1F6MKXD4CRQ3GPYK9C	pset_01KZ6CDNNK545FEKRCD12KAPHC	pvps_01KZ6CDNX6GN272ZCJDKWPPBVH	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1G9Z9GA66NY896MWJB	pset_01KZ6CDNNMZF22XSQ22QK8000B	pvps_01KZ6CDNX67GCVK82QNZGY16PA	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1G1784T6VDXBQEPWMR	pset_01KZ6CDNNNZ1KHTKKD6Z3YENZV	pvps_01KZ6CDNX7KPTBKPW94J31YH94	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1H97E8VQCPEJCP8EMZ	pset_01KZ6CDNNPZETNDY6QWH647R09	pvps_01KZ6CDNX7P8SWKC38CBX3HAQA	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1KKR4BQ649PNPKSRRS	pset_01KZ6CDNNR3JGPV12PQFYBQY1W	pvps_01KZ6CDNX867XZHNPTJWWT4C7A	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1KVCEACGFHZSMP9ZDM	pset_01KZ6CDNNSRVHF4WG29TSKD5A7	pvps_01KZ6CDNX8SM8205CEG5WBJPK6	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1MS3MSJD2VHRBNE50K	pset_01KZ6CDNNXZ0AF5A8R1PCE2S0J	pvps_01KZ6CDNX9XC9ZY4482B6CNCAD	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ6CDN1NZQMAWTPYA4ZYR226	pset_01KZ6CDNNYENYC42ZBSNDHF1HD	pvps_01KZ6CDNX9FQ39HA7ZE5TFC8BY	2026-08-04 12:36:50.522561+00	2026-08-04 12:36:50.522561+00	\N
variant_01KZ4ZYA0YYCZZNT6W0103RYZ9	pset_01KZ4ZYAA45FQ0CPRFW5VHD35Y	pvps_01KZ4ZYAFZ5RBV9JTMM4SKWAWW	2026-08-03 23:39:30.470869+00	2026-08-04 12:40:32.424+00	2026-08-04 12:40:32.421+00
variant_01KZ4ZYA0ZFFTFZ31Q0C20Y3NB	pset_01KZ4ZYAABYMV6PEV1N0KV2YDY	pvps_01KZ4ZYAG46BZ5DQYAFBZGD589	2026-08-03 23:39:30.470869+00	2026-08-04 12:40:32.424+00	2026-08-04 12:40:32.421+00
variant_01KZ6WJVKFR316FW891PNWHVQD	pset_01KZ6WJVP2HVKJ0BEP47GQ3PQ3	pvps_01KZ6WJVQWFM48WHGWX06TGPB4	2026-08-04 17:19:18.289024+00	2026-08-04 17:19:18.289024+00	\N
variant_01KYYM1341B5044GXK40CJMJWS	pset_01KYYM13A3ZTAMWR05QTY3DXKB	pvps_01KYYM13E8ACYTTE482N5PFANY	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.528+00	2026-08-04 17:20:30.524+00
variant_01KYYM134234VY30GKJKYR1XXD	pset_01KYYM13A4ZEYEJAT7XJEGH31M	pvps_01KYYM13E928T5TX4J72BE5FQG	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.528+00	2026-08-04 17:20:30.524+00
variant_01KYYM1343PRJJH61TXGN2HFN9	pset_01KYYM13A52R22MTK2HG0XMGZA	pvps_01KYYM13EARJ6TXZFWXW7EPR0Z	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.528+00	2026-08-04 17:20:30.524+00
variant_01KYYM1344YXSMB3Z9PJ1RD690	pset_01KYYM13A6V5WG03MMKC2RKWW5	pvps_01KYYM13EB232197F1ZBHWVAVN	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.528+00	2026-08-04 17:20:30.524+00
variant_01KYYM1344NRBNDRH7CHJEMNG1	pset_01KYYM13A8PYJ8D9N438SJ39AX	pvps_01KYYM13ECBCZWBEMM4BT8S619	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.528+00	2026-08-04 17:20:30.524+00
variant_01KYYM1345FZGQVZ3RPRD4PDWY	pset_01KYYM13A936N58HMTFK4YCGBR	pvps_01KYYM13ED6S46Y3X5DVRGC5GB	2026-08-01 12:15:52.314098+00	2026-08-04 17:20:30.528+00	2026-08-04 17:20:30.524+00
variant_01KZ6Y4FXAJN1YVKWVK5SSMWA8	pset_01KZ6Y4FYJMV63HRYPHHA230T3	pvps_01KZ6Y4FZR8TA458DR1A7R8A3W	2026-08-04 17:46:24.683176+00	2026-08-04 17:46:24.683176+00	\N
variant_01KZ7FWZA010EWS2V928NHNZ7N	pset_01KZ7FWZD6A2EJKKD32PG678N5	pvps_01KZ7FWZEEC8VRSNXDNV8FMYSZ	2026-08-04 22:56:52.603316+00	2026-08-04 22:56:52.603316+00	\N
variant_01KZ7G009WEW98MFB3QBRNDP4D	pset_01KZ7G00C9T9GRKTERKNQ0AKY9	pvps_01KZ7G00DHGZC8ZEHNFB58QK77	2026-08-04 22:58:31.986892+00	2026-08-04 22:58:31.986892+00	\N
variant_01KZ7G0ZKWRSZJQHF6PR6CAYXW	pset_01KZ7G0ZNWPDRATGA1TQ0KV501	pvps_01KZ7G0ZPSJHGWC3D729SMJ2PN	2026-08-04 22:59:04.043587+00	2026-08-04 22:59:04.043587+00	\N
variant_01KZ7G1RFTF7XZBJ3CPQ0Y9ZHJ	pset_01KZ7G1RJNKD7G9NKJ1T32WW3W	pvps_01KZ7G1RKJEW1GS3YJHJMZKYY3	2026-08-04 22:59:29.528301+00	2026-08-04 22:59:29.528301+00	\N
variant_01KZ7G2M0XE2YN52YMDD1VCDXE	pset_01KZ7G2M2TG78ZM1094EW3EECX	pvps_01KZ7G2M3PAXCS2KDERRA90T79	2026-08-04 22:59:57.391207+00	2026-08-04 22:59:57.391207+00	\N
variant_01KZ7G3DTYYJNWSTGA7SR4TK8F	pset_01KZ7G3DWW9CS6ZRVZGB2XDDK7	pvps_01KZ7G3DXX6S7MEC1Y46ZPE1CF	2026-08-04 23:00:24.06682+00	2026-08-04 23:00:24.06682+00	\N
variant_01KZ7G461AW41JCCGV19F1TSCW	pset_01KZ7G466C0XTY9TNGAYJC5M74	pvps_01KZ7G467EQGJ0C809D41N3PZ7	2026-08-04 23:00:48.965876+00	2026-08-04 23:00:48.965876+00	\N
variant_01KZ7G55J7AKM71K2YFG8Z65KM	pset_01KZ7G55N5C987261BEKQF16D3	pvps_01KZ7G55PT4E25W2VGY0EDFKRT	2026-08-04 23:01:21.191613+00	2026-08-04 23:01:21.191613+00	\N
variant_01KZ8XR8CFJK8BSJGYD2793PY1	pset_01KZ8XR8MJH5M9M0PBRECGC6DR	pvps_01KZ8XR8QMRQV4X0Y0J52ZS79P	2026-08-05 12:18:12.906805+00	2026-08-05 12:18:12.906805+00	\N
variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	pset_01KZ8XZHN72K3KKVGC31NBVKK3	pvps_01KZ8XZHST8MW00TP88RC15855	2026-08-05 12:22:11.526907+00	2026-08-05 12:22:11.526907+00	\N
variant_01KZ8Y13W8VX79ZZNZBT53W5R2	pset_01KZ8Y14442HDN7BHB1XXP97KY	pvps_01KZ8Y148D0G33V413W3QEGQP2	2026-08-05 12:23:03.157796+00	2026-08-05 12:23:03.157796+00	\N
variant_01KZ8Y1YJ5B7B01RA7EPJYV4S9	pset_01KZ8Y1YWRWCKRP4QHP4BCDV5N	pvps_01KZ8Y1Z1ABJSVWC4PHDBWHM0A	2026-08-05 12:23:30.584667+00	2026-08-05 12:23:30.584667+00	\N
variant_01KZ8Y2P3AG1XR85T301TYPVND	pset_01KZ8Y2PDT81JKP3TE6W8T14V0	pvps_01KZ8Y2PHF8DMDFFMH5S4KF64Q	2026-08-05 12:23:54.662532+00	2026-08-05 12:23:54.662532+00	\N
\.


--
-- Data for Name: product_variant_product_image; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.product_variant_product_image (id, variant_id, image_id, created_at, updated_at, deleted_at) FROM stdin;
pvpi_01KZ7ECN8DKCEAYK8QFV38W06X	variant_01KZ6CDMZYBWZ3RGMVCTK1WV79	img_01KZ6CDKZDA3AGKBF6VW4HKCFR	2026-08-04 22:30:29.389+00	2026-08-04 22:30:29.389+00	\N
pvpi_01KZ7EGNFS1EXZBCCMH21QZ6XP	variant_01KZ6CDMZYZPQGK5D855RTKEQN	img_01KZ6CDKZDJWD80YTP7G170VRJ	2026-08-04 22:32:40.698+00	2026-08-04 22:32:40.698+00	\N
pvpi_01KZ7FY6MJHM4C5Z0GF5N1FGCK	variant_01KZ7FWZA010EWS2V928NHNZ7N	img_01KZ6CDKZFZPBDD48M37ZPTSBH	2026-08-04 22:57:32.82+00	2026-08-04 22:57:32.82+00	\N
pvpi_01KZ7FY6MKBRAWYQ6NA3T00EJ0	variant_01KZ7FWZA010EWS2V928NHNZ7N	img_01KZ6CDKZF1TJRZ6F8HSJH3N4V	2026-08-04 22:57:32.82+00	2026-08-04 22:57:32.82+00	\N
pvpi_01KZ7FY6MKB31F96E4K8JE3A3G	variant_01KZ7FWZA010EWS2V928NHNZ7N	img_01KZ6CDKZHSTA34HBRWPEQ4AV0	2026-08-04 22:57:32.82+00	2026-08-04 22:57:32.82+00	\N
pvpi_01KZ7FY6MKQN7NJ9QR253EDMR4	variant_01KZ7FWZA010EWS2V928NHNZ7N	img_01KZ6CDKZG2YKRS3AR52QB2AEB	2026-08-04 22:57:32.82+00	2026-08-04 22:57:32.82+00	\N
pvpi_01KZ8SEAEP3RX3RDNFFPZF0EZ5	variant_01KZ6CDN058P9B4TRNRBWAQ4MF	img_01KZ6CDKZJ945EZ4JK5HNGVV1R	2026-08-05 11:02:52.631+00	2026-08-05 11:02:52.631+00	\N
pvpi_01KZ8SEAEQQ69BDCR7M30X372H	variant_01KZ6CDN058P9B4TRNRBWAQ4MF	img_01KZ6CDKZJKK62WR6DP3JRH03Z	2026-08-05 11:02:52.631+00	2026-08-05 11:02:52.631+00	\N
pvpi_01KZ8SESTQX6QDQS8Z4YCJAQDP	variant_01KZ6CDN06ANBG61KQ092TD09Y	img_01KZ6CDKZJGCC9Y8P01K084RQX	2026-08-05 11:03:08.376+00	2026-08-05 11:03:08.376+00	\N
pvpi_01KZ8SESTRJEKQ38HPNT0XD6BC	variant_01KZ6CDN06ANBG61KQ092TD09Y	img_01KZ6CDKZJ583E0XQF7A1FJJ32	2026-08-05 11:03:08.377+00	2026-08-05 11:03:08.377+00	\N
pvpi_01KZ8XW46D4W48HHX7P1QF054Q	variant_01KZ8XR8CFJK8BSJGYD2793PY1	img_01KZ6CDKZPH7E7386GXPAPTS2X	2026-08-05 12:20:19.281+00	2026-08-05 12:20:19.281+00	\N
pvpi_01KZ8XW46EFR6QW4MHK3XBXSJ3	variant_01KZ8XR8CFJK8BSJGYD2793PY1	img_01KZ6CDKZP8ZMTRV268NTTQAVK	2026-08-05 12:20:19.282+00	2026-08-05 12:20:19.282+00	\N
pvpi_01KZ8XW46FG9821DXKVBCZWMCH	variant_01KZ8XR8CFJK8BSJGYD2793PY1	img_01KZ6CDKZP2F0RBMPM92JMZ51W	2026-08-05 12:20:19.282+00	2026-08-05 12:20:19.282+00	\N
pvpi_01KZ8XW46GD67BGVP0H9EP6X3G	variant_01KZ8XR8CFJK8BSJGYD2793PY1	img_01KZ6CDKZRGQQVX80DCWPD3ZDB	2026-08-05 12:20:19.282+00	2026-08-05 12:20:19.282+00	\N
pvpi_01KZ8XW46HT3VBV5Y4K38Y2AYT	variant_01KZ8XR8CFJK8BSJGYD2793PY1	img_01KZ6CDKZRJKQA2MFRHJGTAXY2	2026-08-05 12:20:19.282+00	2026-08-05 12:20:19.282+00	\N
pvpi_01KZ8Y4510ZNDEZ18K8SGW2J6E	variant_01KZ8Y1YJ5B7B01RA7EPJYV4S9	img_01KZ6CDKZQ4ZXFBTN5MC55A5X2	2026-08-05 12:24:42.274+00	2026-08-05 12:24:42.274+00	\N
pvpi_01KZ8Y4XH367A13FPDM2C12G7J	variant_01KZ8Y13W8VX79ZZNZBT53W5R2	img_01KZ6CDKZP6Q3SC3CV3RNMD3JB	2026-08-05 12:25:07.37+00	2026-08-05 12:25:07.37+00	\N
pvpi_01KZ8Y4XH4ZFZASYJS6WXV15AP	variant_01KZ8Y13W8VX79ZZNZBT53W5R2	img_01KZ6CDKZR7BGK3N7HCFPYN724	2026-08-05 12:25:07.372+00	2026-08-05 12:25:07.372+00	\N
pvpi_01KZ8Y4XH5BREBFNHDWNXXNDVT	variant_01KZ8Y13W8VX79ZZNZBT53W5R2	img_01KZ6CDKZQ6JVPJS0PDPECXMNF	2026-08-05 12:25:07.372+00	2026-08-05 12:25:07.373+00	\N
pvpi_01KZ8Y4XH5HG8FQFBTG4PF17MX	variant_01KZ8Y13W8VX79ZZNZBT53W5R2	img_01KZ6CDKZSF7AJM3X7S0RMVNAE	2026-08-05 12:25:07.373+00	2026-08-05 12:25:07.373+00	\N
pvpi_01KZ8Y4XH80H9JMSGD48S0S1E8	variant_01KZ8Y13W8VX79ZZNZBT53W5R2	img_01KZ6CDKZS1FXCGES6GTFZ5Z3T	2026-08-05 12:25:07.373+00	2026-08-05 12:25:07.373+00	\N
pvpi_01KZ8Y5TMBK382DB60SFRJWWWB	variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	img_01KZ6CDKZN41RZJCDAB18AQ9FK	2026-08-05 12:25:37.167+00	2026-08-05 12:25:37.167+00	\N
pvpi_01KZ8Y5TMDC1ZAW580EY8KCF02	variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	img_01KZ6CDKZPWT4FXKW3TRH7KEV1	2026-08-05 12:25:37.167+00	2026-08-05 12:25:37.167+00	\N
pvpi_01KZ8Y5TMENNA81SECDBGDDTMY	variant_01KZ8XZHBP1ZNB5B9QYGDFQ637	img_01KZ6CDKZQ503W0RV9SNMZ94F1	2026-08-05 12:25:37.167+00	2026-08-05 12:25:37.167+00	\N
pvpi_01KZ8Y806A76F9C6WBX1GTQ5PH	variant_01KZ8Y2P3AG1XR85T301TYPVND	img_01KZ6CDKZR2SYA4K7WTQ17EP8N	2026-08-05 12:26:48.4+00	2026-08-05 12:26:48.4+00	\N
pvpi_01KZ8YG8ZV9K6HX89M9CJA1MJF	variant_01KZ6CDN099BRKMZH8A2C73YF6	img_01KZ6CDKZNC4N3N88DWT4FFYMY	2026-08-05 12:31:19.551+00	2026-08-05 12:31:19.551+00	\N
pvpi_01KZ8YG8ZVR26REC04DZ6ZG12R	variant_01KZ6CDN099BRKMZH8A2C73YF6	img_01KZ6CDKZN01EMHX6SP2SA6KQ0	2026-08-05 12:31:19.551+00	2026-08-05 12:31:19.551+00	\N
pvpi_01KZ8YG8ZW36S2XMXDN0PGYJKZ	variant_01KZ6CDN099BRKMZH8A2C73YF6	img_01KZ6CDKZM4M38N01N7HTSFMVX	2026-08-05 12:31:19.551+00	2026-08-05 12:31:19.551+00	\N
pvpi_01KZ8YG8ZXKYJ9YZQ1SX1FZ295	variant_01KZ6CDN099BRKMZH8A2C73YF6	img_01KZ6CDKZMDXAXBZ53JBZGX9Q6	2026-08-05 12:31:19.551+00	2026-08-05 12:31:19.551+00	\N
pvpi_01KZ8YHM88YR76Z96Z8SFB8FR7	variant_01KZ6CDN09M50P581MG6ZSVJG3	img_01KZ6CDKZMS8FG4QJ3NKQF7XP8	2026-08-05 12:32:03.85+00	2026-08-05 12:32:03.85+00	\N
pvpi_01KZ8YHM89BMGEY6SZ8V2H2PKC	variant_01KZ6CDN09M50P581MG6ZSVJG3	img_01KZ6CDKZMEFYTNW3ZRYQW7P1Q	2026-08-05 12:32:03.85+00	2026-08-05 12:32:03.85+00	\N
pvpi_01KZ8YRDNDPR9C7JJNM2QE9MSX	variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	img_01KZ6CDKZSJCTJ542JVV8JDY3X	2026-08-05 12:35:46.483+00	2026-08-05 12:35:46.484+00	\N
pvpi_01KZ8YRDNDQF8G9MBXWTGTR38C	variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	img_01KZ6CDKZT1S597P086GWB9J1X	2026-08-05 12:35:46.484+00	2026-08-05 12:35:46.484+00	\N
pvpi_01KZ8YRDNEPATWXX9BQ5CB852G	variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	img_01KZ6CDKZTGXGDPGBFVXCQZCCK	2026-08-05 12:35:46.484+00	2026-08-05 12:35:46.484+00	\N
pvpi_01KZ8YRDNE90S221WF8XKK7QPS	variant_01KZ6CDN0DCKC7SPQXFPCRTR0Q	img_01KZ6CDKZT3ZXPP14DF2VW56TK	2026-08-05 12:35:46.484+00	2026-08-05 12:35:46.484+00	\N
pvpi_01KZ8YVDNS8TEHERWKWYYYEB2T	variant_01KZ6CDN0K939YV5FA1MY0ET8V	img_01KZ6CDM0338K2P6NKR4GT7HKQ	2026-08-05 12:37:24.801+00	2026-08-05 12:37:24.801+00	\N
pvpi_01KZ8YVDNT86V3XF86ZWDVJGH7	variant_01KZ6CDN0K939YV5FA1MY0ET8V	img_01KZ6CDM01H88J4X62T6TBXYY9	2026-08-05 12:37:24.801+00	2026-08-05 12:37:24.801+00	\N
pvpi_01KZ8YVDNTQYKAHX1C4BS0CKHK	variant_01KZ6CDN0K939YV5FA1MY0ET8V	img_01KZ6CDM020S18GHF39QN19KXF	2026-08-05 12:37:24.802+00	2026-08-05 12:37:24.802+00	\N
pvpi_01KZ8YVDNW01DEK0C116J8C88X	variant_01KZ6CDN0K939YV5FA1MY0ET8V	img_01KZ6CDM020RAYQ2SMTT3VZH1P	2026-08-05 12:37:24.802+00	2026-08-05 12:37:24.802+00	\N
pvpi_01KZ8YX2XR6PBK99S85TRVV8H5	variant_01KZ6CDN0M5W17E3B90MHTWGP1	img_01KZ6CDM0310WZB3F1RRZ75XP6	2026-08-05 12:38:19.323+00	2026-08-05 12:38:19.323+00	\N
pvpi_01KZ8YX2XSK2CN4C9F8BG707QP	variant_01KZ6CDN0M5W17E3B90MHTWGP1	img_01KZ6CDM02FSR15Z9H12AYR9Y0	2026-08-05 12:38:19.323+00	2026-08-05 12:38:19.323+00	\N
pvpi_01KZ8YX2XTRKBKSTYETGZEHECZ	variant_01KZ6CDN0M5W17E3B90MHTWGP1	img_01KZ6CDM02PHGZPHPRQ85MS7RR	2026-08-05 12:38:19.323+00	2026-08-05 12:38:19.323+00	\N
pvpi_01KZ8Z106TTDYA2K42X2F0WMXA	variant_01KZ6CDN0JPQ4EDYBNDMQ0PN93	img_01KZ6CDM00QH9Y0ZH5KGBP61RW	2026-08-05 12:40:27.612+00	2026-08-05 12:40:27.612+00	\N
pvpi_01KZ8Z106VKVB4PDAX69YXDBZ5	variant_01KZ6CDN0JPQ4EDYBNDMQ0PN93	img_01KZ6CDM00Z3R3FZ5JA4M0XCZW	2026-08-05 12:40:27.612+00	2026-08-05 12:40:27.613+00	\N
pvpi_01KZ8Z4GM1M0G7E7X9Y6ST0EAF	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZYZVBT9FX4RDZXZ5ZN	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z4GM2GKZRWF3T04W61RTQ	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZY0AKANQJX2R2FTGJP	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z4GM2VZKDCTBJWQ998CE8	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZZNRBW3RBP4MNRH08E	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z4GM3RSKKB23XCF59Z2CP	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZZZGF4KJ7A6WQD6V21	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z4GM4RRSQE8SGNXTMX2YM	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZZEFAR9J0MSP5TKXQK	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z4GM404GFJAJKFFT6DRV9	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZZB89EZ0DHHW1PY8BE	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z4GM5KNST4W2FG58ZYHS7	variant_01KZ6CDN0H6QCATENB9WDW6BEJ	img_01KZ6CDKZZD9EANV7N1PFMW6PH	2026-08-05 12:42:22.726+00	2026-08-05 12:42:22.726+00	\N
pvpi_01KZ8Z9NHD5NDAANYRMW9CN999	variant_01KZ6CDN0GQNTK1HFBJ09HS9PC	img_01KZ6CDKZXJHXJ9F7ZYX48E9YJ	2026-08-05 12:45:11.6+00	2026-08-05 12:45:11.6+00	\N
pvpi_01KZ8Z9NHFYFJ77H5FJ657RJP5	variant_01KZ6CDN0GQNTK1HFBJ09HS9PC	img_01KZ6CDKZY77P28F06T7W66SSA	2026-08-05 12:45:11.6+00	2026-08-05 12:45:11.6+00	\N
pvpi_01KZ8ZCBGXVR0HZBMQWG5JZB3A	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM054NAG2NHXXHHEB71Y	2026-08-05 12:46:39.652+00	2026-08-05 12:46:39.652+00	\N
pvpi_01KZ8ZCBGY5V9V4Y2GFJPRDEBV	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM060HRB2HJZ4NSWAWVJ	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBGYQKM6XKV8V91W6587	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM06DEF8X172CRTNGY7B	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBGZ9PDR288T7AM551E0	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM07MZF1X1Z5VJ1AYXRV	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBGZ5DJE6CPNSP912WHB	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM09BE6YVPVGMWQ0Y0KC	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBH0QTDCK4P6NYYKVHJT	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM0AZEEYVTP2VZ0Z2E63	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBH1ACQBZDHZ475PTK0K	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM0AVVQWX1MMS319K9A6	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBH2QSD6SV126NQ2ASJ5	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM0APPFA3ZHK73B9HHPC	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBH2GSPZSH770NF0M75W	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM0AXQQY283244RGV5XC	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBH3VNC4C42D3SBA0Z5J	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM0B3QDAEBGT4QK7S50J	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZCBH32S62SXZJAJH27VBC	variant_01KZ6CDN0NQQAAPRQ7TBNR1DVJ	img_01KZ6CDM06D10H51SGZETKNX5H	2026-08-05 12:46:39.653+00	2026-08-05 12:46:39.653+00	\N
pvpi_01KZ8ZD7D3TWASQPBV268MT6B0	variant_01KZ6CDN0P9DETBPWK54M1K7AM	img_01KZ6CDM069W6QM0RKJQ949ADW	2026-08-05 12:47:08.197+00	2026-08-05 12:47:08.197+00	\N
pvpi_01KZ8ZHQNQ27T2FY8AG7938CCE	variant_01KZ6CDN0RZDNFJW993VCF7RJ8	img_01KZ6CDM0DH0YYGZK9DFQFGY6N	2026-08-05 12:49:35.93+00	2026-08-05 12:49:35.93+00	\N
pvpi_01KZ8ZHQNRJ86SVVM0N9J34YW8	variant_01KZ6CDN0RZDNFJW993VCF7RJ8	img_01KZ6CDM0EC4S3F9GCR754A8XW	2026-08-05 12:49:35.93+00	2026-08-05 12:49:35.93+00	\N
pvpi_01KZ8ZHQNSBMFPFQAVTYSWAC61	variant_01KZ6CDN0RZDNFJW993VCF7RJ8	img_01KZ6CDM0EJFZ9PQW680TT5G1W	2026-08-05 12:49:35.93+00	2026-08-05 12:49:35.93+00	\N
pvpi_01KZ8ZN5JFVK783M5BWD0ZGQ01	variant_01KZ6CDN0Q29QE56892FQQ1MP6	img_01KZ6CDM0CD3V1P2GHZW7PQPQQ	2026-08-05 12:51:28.465+00	2026-08-05 12:51:28.465+00	\N
pvpi_01KZ8ZN5JGB59SCK95GNNE87T5	variant_01KZ6CDN0Q29QE56892FQQ1MP6	img_01KZ6CDM0CYHWHR5PY6NSHQKKX	2026-08-05 12:51:28.465+00	2026-08-05 12:51:28.465+00	\N
pvpi_01KZ8ZN5JG817TV0FWV54CZN18	variant_01KZ6CDN0Q29QE56892FQQ1MP6	img_01KZ6CDM0CC0EFGEVNNV3N1CC2	2026-08-05 12:51:28.465+00	2026-08-05 12:51:28.465+00	\N
pvpi_01KZ8ZTJZBAJBJJ4XXR7TWPE3B	variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	img_01KZ6CDM03P6D905PJVZFYP1Z2	2026-08-05 12:54:26.031+00	2026-08-05 12:54:26.031+00	\N
pvpi_01KZ8ZTJZCRTW65P7R7GC0KYK1	variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	img_01KZ6CDM04J6C3TE37JPWZG4GW	2026-08-05 12:54:26.031+00	2026-08-05 12:54:26.031+00	\N
pvpi_01KZ8ZTJZD4P1Y0S9ZPMSCYYT3	variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	img_01KZ6CDM045PJ6NX53QN8CTYCS	2026-08-05 12:54:26.031+00	2026-08-05 12:54:26.031+00	\N
pvpi_01KZ8ZTJZE9X14K2JJNVEPH2HY	variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	img_01KZ6CDM04NQ02DX8RJFX9RP5Q	2026-08-05 12:54:26.031+00	2026-08-05 12:54:26.031+00	\N
pvpi_01KZ8ZTJZE2RPQCGHBCZZECTDA	variant_01KZ6CDN0N9Y6JW9F2GMBNPF3F	img_01KZ6CDM052EPRFXN6DJYEVNTJ	2026-08-05 12:54:26.031+00	2026-08-05 12:54:26.031+00	\N
pvpi_01KZ8ZVF8EC8F3NKGV7HD4K97Y	variant_01KZ6CDN0RFPEPFGWN4RW27EZM	img_01KZ6CDM0FTVCFQC9DHM37ZTD7	2026-08-05 12:54:54.993+00	2026-08-05 12:54:54.993+00	\N
pvpi_01KZ8ZVF8FW3RJFVB64HS2P3AT	variant_01KZ6CDN0RFPEPFGWN4RW27EZM	img_01KZ6CDM0FVVMVF5N8CQ80VGTR	2026-08-05 12:54:54.993+00	2026-08-05 12:54:54.993+00	\N
pvpi_01KZ8ZVF8GBASFV54MT0B64CS0	variant_01KZ6CDN0RFPEPFGWN4RW27EZM	img_01KZ6CDM0FBC8A2DSZ3WPTCHGE	2026-08-05 12:54:54.993+00	2026-08-05 12:54:54.993+00	\N
pvpi_01KZ8ZZXAR1HEK2NFSRM8WT3KX	variant_01KZ6CDN0SBFFRP1A7S1D6Y351	img_01KZ6CDM0GCGBCS60JNRBCMXS2	2026-08-05 12:57:20.481+00	2026-08-05 12:57:20.481+00	\N
pvpi_01KZ8ZZXAS7WFK6YX5NQJ5XE27	variant_01KZ6CDN0SBFFRP1A7S1D6Y351	img_01KZ6CDM0GV5QP8RPVJQWY8M43	2026-08-05 12:57:20.482+00	2026-08-05 12:57:20.482+00	\N
pvpi_01KZ8ZZXAT7R7D7E226FPPRVNG	variant_01KZ6CDN0SBFFRP1A7S1D6Y351	img_01KZ6CDM0HQ91XKHN7PY2AG5X9	2026-08-05 12:57:20.482+00	2026-08-05 12:57:20.482+00	\N
pvpi_01KZ8ZZXAVX7XS9HMJ2W08Q1PW	variant_01KZ6CDN0SBFFRP1A7S1D6Y351	img_01KZ6CDM0H67Q65E1AHYR50W18	2026-08-05 12:57:20.482+00	2026-08-05 12:57:20.482+00	\N
pvpi_01KZ8ZZXAX91PXKYJCKPATCMCT	variant_01KZ6CDN0SBFFRP1A7S1D6Y351	img_01KZ6CDM0HKD7DVHZ357VRHKAX	2026-08-05 12:57:20.482+00	2026-08-05 12:57:20.482+00	\N
pvpi_01KZ8ZZXAYEKZY2KF81EY3A69X	variant_01KZ6CDN0SBFFRP1A7S1D6Y351	img_01KZ6CDM0HF73EFFJBR8NQDFNQ	2026-08-05 12:57:20.482+00	2026-08-05 12:57:20.482+00	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status, is_tax_inclusive, "limit", used, metadata) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code, attribute) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget_usage; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_campaign_budget_usage (id, attribute_value, used, budget_id, raw_used, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: property_label; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.property_label (id, entity, property, label, description, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01KYYNKWB2RHJX8B816F5ZF3S3	admin@test.com	emailpass	authid_01KYYNKWB7MK8RWTYEF6TC0HCS	\N	{"password": "c2NyeXB0AA8AAAAIAAAAATxwHNHxCTK28LneX9F/t1nfAWquFwugJihskY4uAbuO4LR1IQn+Iz02IDPWcnILX8kVdYHU5HGAI91xAo8ndsMSYl3z9Q8rqBGhsYhYcl71"}	2026-08-01 12:43:36.173+00	2026-08-01 12:43:36.173+00	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01KYYM10VZP68APXZK8WHKMPA0	sc_01KYYM10T2S0GBNVGXG96MYD0X	pksc_01KYYM10Z3A0GE8KBJF7CRH169	2026-08-01 12:15:49.725996+00	2026-08-01 12:15:49.725996+00	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at, code) FROM stdin;
refr_01KYYKRRYW5FAEH9G8S56MP1KK	Shipping Issue	Refund due to lost, delayed, or misdelivered shipment	\N	2026-08-01 12:11:17.575944+00	2026-08-01 12:11:17.575944+00	\N	shipping_issue
refr_01KYYKRRZKH6GBSYF4X5589EXN	Customer Care Adjustment	Refund given as goodwill or compensation for inconvenience	\N	2026-08-01 12:11:17.575944+00	2026-08-01 12:11:17.575944+00	\N	customer_care_adjustment
refr_01KYYKRRZKFE5A56W140Y91Q0Y	Pricing Error	Refund to correct an overcharge, missing discount, or incorrect price	\N	2026-08-01 12:11:17.575944+00	2026-08-01 12:11:17.575944+00	\N	pricing_error
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01KYYM116XC444G5JS3BHE5HHB	India	inr	\N	2026-08-01 12:15:50.031+00	2026-08-03 22:39:26.12+00	\N	t
reg_01KZ7F0JSMXZXMJNNA4W7HRQTX	USA	usd	\N	2026-08-04 22:41:22.229+00	2026-08-04 22:41:22.229+00	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2026-08-01 12:14:52.387+00	2026-08-01 12:14:52.387+00	\N
al	alb	008	ALBANIA	Albania	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2026-08-01 12:14:52.388+00	2026-08-01 12:14:52.388+00	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
by	blr	112	BELARUS	Belarus	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
bz	blz	084	BELIZE	Belize	\N	\N	2026-08-01 12:14:52.389+00	2026-08-01 12:14:52.389+00	\N
bj	ben	204	BENIN	Benin	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
ca	can	124	CANADA	Canada	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2026-08-01 12:14:52.39+00	2026-08-01 12:14:52.39+00	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
td	tcd	148	CHAD	Chad	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cl	chl	152	CHILE	Chile	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cn	chn	156	CHINA	China	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
km	com	174	COMOROS	Comoros	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cg	cog	178	CONGO	Congo	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cu	cub	192	CUBA	Cuba	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2026-08-01 12:14:52.391+00	2026-08-01 12:14:52.391+00	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
fj	fji	242	FIJI	Fiji	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
fi	fin	246	FINLAND	Finland	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
ga	gab	266	GABON	Gabon	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
gh	gha	288	GHANA	Ghana	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2026-08-01 12:14:52.392+00	2026-08-01 12:14:52.392+00	\N
gr	grc	300	GREECE	Greece	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gu	gum	316	GUAM	Guam	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
ht	hti	332	HAITI	Haiti	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
is	isl	352	ICELAND	Iceland	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.393+00	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2026-08-01 12:14:52.393+00	2026-08-01 12:14:52.394+00	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
il	isr	376	ISRAEL	Israel	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
je	jey	832	JERSEY	Jersey	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
ke	ken	404	KENYA	Kenya	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
ly	lby	434	LIBYA	Libya	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
mo	mac	446	MACAO	Macao	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2026-08-01 12:14:52.394+00	2026-08-01 12:14:52.394+00	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
ml	mli	466	MALI	Mali	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mt	mlt	470	MALTA	Malta	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mc	mco	492	MONACO	Monaco	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
nr	nru	520	NAURU	Nauru	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
np	npl	524	NEPAL	Nepal	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
ne	ner	562	NIGER	Niger	\N	\N	2026-08-01 12:14:52.395+00	2026-08-01 12:14:52.395+00	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
nu	niu	570	NIUE	Niue	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
no	nor	578	NORWAY	Norway	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
om	omn	512	OMAN	Oman	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pw	plw	585	PALAU	Palau	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pa	pan	591	PANAMA	Panama	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pe	per	604	PERU	Peru	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.396+00	\N
pl	pol	616	POLAND	Poland	\N	\N	2026-08-01 12:14:52.396+00	2026-08-01 12:14:52.397+00	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
qa	qat	634	QATAR	Qatar	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
re	reu	638	REUNION	Reunion	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
in	ind	356	INDIA	India	reg_01KYYM116XC444G5JS3BHE5HHB	\N	2026-08-01 12:14:52.393+00	2026-08-03 22:41:44.258+00	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2026-08-01 12:14:52.397+00	2026-08-01 12:14:52.397+00	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
so	som	706	SOMALIA	Somalia	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2026-08-01 12:14:52.398+00	2026-08-01 12:14:52.398+00	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
th	tha	764	THAILAND	Thailand	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tg	tgo	768	TOGO	Togo	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
to	ton	776	TONGA	Tonga	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
us	usa	840	UNITED STATES	United States	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2026-08-01 12:14:52.399+00	2026-08-01 12:14:52.399+00	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2026-08-01 12:14:52.4+00	2026-08-01 12:14:52.4+00	\N
dk	dnk	208	DENMARK	Denmark	\N	\N	2026-08-01 12:14:52.391+00	2026-08-03 22:41:33.475+00	\N
fr	fra	250	FRANCE	France	\N	\N	2026-08-01 12:14:52.392+00	2026-08-03 22:41:33.475+00	\N
de	deu	276	GERMANY	Germany	\N	\N	2026-08-01 12:14:52.392+00	2026-08-03 22:41:33.475+00	\N
it	ita	380	ITALY	Italy	\N	\N	2026-08-01 12:14:52.394+00	2026-08-03 22:41:33.475+00	\N
es	esp	724	SPAIN	Spain	\N	\N	2026-08-01 12:14:52.398+00	2026-08-03 22:41:33.475+00	\N
se	swe	752	SWEDEN	Sweden	\N	\N	2026-08-01 12:14:52.398+00	2026-08-03 22:41:33.476+00	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	\N	\N	2026-08-01 12:14:52.399+00	2026-08-03 22:41:33.475+00	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01KYYM116XC444G5JS3BHE5HHB	pp_system_default	regpp_01KYYM11CB1CH2YSEH1NDYGJY6	2026-08-01 12:15:50.150066+00	2026-08-01 12:15:50.150066+00	\N
reg_01KZ7F0JSMXZXMJNNA4W7HRQTX	pp_system_default	regpp_01KZ7F0JTE0GY9VC7J5J2P6EAF	2026-08-04 22:41:22.384402+00	2026-08-04 22:41:22.384402+00	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01KYYM10T2S0GBNVGXG96MYD0X	Default Sales Channel	Created by Medusa	f	\N	2026-08-01 12:15:49.575+00	2026-08-01 12:15:49.575+00	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01KYYM10T2S0GBNVGXG96MYD0X	sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	scloc_01KYYM1299HP4JGM805W8S4CQF	2026-08-01 12:15:51.104715+00	2026-08-01 12:15:51.104715+00	\N
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-normalize-currency-codes-normalization.js	2026-08-01 12:14:56.180336+00	2026-08-01 12:14:56.527491+00
2	migrate-product-option-link-ids.js	2026-08-01 12:14:56.574523+00	2026-08-01 12:14:56.696383+00
3	migrate-product-shipping-profile.js	2026-08-01 12:15:48.628066+00	2026-08-01 12:15:48.874167+00
4	migrate-tax-region-provider.js	2026-08-01 12:15:48.951306+00	2026-08-01 12:15:49.016779+00
5	reconcile-inventory-reserved-quantity.js	2026-08-01 12:15:49.09725+00	2026-08-01 12:15:49.172991+00
6	initial-data-seed.ts	2026-08-01 12:15:49.373286+00	2026-08-01 12:15:52.553936+00
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01KYYM11N976QR3F041CH9F994	Andheri	\N	fuset_01KYYM11N9M85PX2PD9JN4DCFX	2026-08-01 12:15:50.444+00	2026-08-04 22:37:36.351+00	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01KYYM11ZVGGTN06EVCM30KH0X	Standard Shipping	flat	serzo_01KYYM11N976QR3F041CH9F994	sp_01KYYM1072RRG3RWZGWTPAENCV	manual_manual	\N	\N	sotype_01KYYM11ZM9MQHRG7FBZ79PPJ7	2026-08-01 12:15:50.787+00	2026-08-01 12:15:50.787+00	\N
so_01KYYM11ZZBBVRR18CBGTQV6KZ	Express Shipping	flat	serzo_01KYYM11N976QR3F041CH9F994	sp_01KYYM1072RRG3RWZGWTPAENCV	manual_manual	\N	\N	sotype_01KYYM11ZWX0ADB300RWZ0NMGB	2026-08-01 12:15:50.788+00	2026-08-01 12:15:50.788+00	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01KYYM11ZVGGTN06EVCM30KH0X	pset_01KYYM122E03VWTGPJNZ3VCJR0	sops_01KYYM127HTGSYKJN158VT7VRK	2026-08-01 12:15:51.04713+00	2026-08-01 12:15:51.04713+00	\N
so_01KYYM11ZZBBVRR18CBGTQV6KZ	pset_01KYYM122KDCQ6M2Q7G20B37NM	sops_01KYYM127MTFGR4FF8CQ0VXZF1	2026-08-01 12:15:51.04713+00	2026-08-01 12:15:51.04713+00	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01KYYM11ZRFMKQTHMF58A0GT6M	enabled_in_store	eq	"true"	so_01KYYM11ZVGGTN06EVCM30KH0X	2026-08-01 12:15:50.788+00	2026-08-01 12:15:50.788+00	\N
sorul_01KYYM11ZSYXQXVXV92ENV31SB	is_return	eq	"false"	so_01KYYM11ZVGGTN06EVCM30KH0X	2026-08-01 12:15:50.789+00	2026-08-01 12:15:50.789+00	\N
sorul_01KYYM11ZX6GA0A306XW1AYJRP	enabled_in_store	eq	"true"	so_01KYYM11ZZBBVRR18CBGTQV6KZ	2026-08-01 12:15:50.789+00	2026-08-01 12:15:50.789+00	\N
sorul_01KYYM11ZXD2SJKTSM8RSHQZTH	is_return	eq	"false"	so_01KYYM11ZZBBVRR18CBGTQV6KZ	2026-08-01 12:15:50.79+00	2026-08-01 12:15:50.79+00	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01KYYM11ZM9MQHRG7FBZ79PPJ7	Standard	Ship in 2-3 days.	standard	2026-08-01 12:15:50.786+00	2026-08-01 12:15:50.786+00	\N
sotype_01KYYM11ZWX0ADB300RWZ0NMGB	Express	Ship in 24 hours.	express	2026-08-01 12:15:50.788+00	2026-08-01 12:15:50.788+00	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01KYYM1072RRG3RWZGWTPAENCV	Default Shipping Profile	default	\N	2026-08-01 12:15:48.963+00	2026-08-01 12:15:48.963+00	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01KYYM11GRJDF0RV3QTBKQYBNJ	2026-08-01 12:15:50.3+00	2026-08-04 22:36:56.866+00	\N	Andheri	laddr_01KYYM11GPYKP9E8EM4X0ZY1HS	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01KYYM11GPYKP9E8EM4X0ZY1HS	2026-08-01 12:15:50.298+00	2026-08-04 22:36:56.834+00	\N	andheri		Strawb	andheri	in	9769586810	mumbai	400099	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01KYYM111TEF1TB5WREKE1SRKQ	Default Store	sc_01KYYM10T2S0GBNVGXG96MYD0X	reg_01KYYM116XC444G5JS3BHE5HHB	\N	\N	2026-08-01 12:15:49.801556+00	2026-08-03 23:19:46.255+00	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01KZ4YT5TRWY03DSZV29Z9GW14	inr	t	store_01KYYM111TEF1TB5WREKE1SRKQ	2026-08-03 23:19:46.353463+00	2026-08-03 23:19:46.353463+00	\N
stocur_01KZ4YT5TS5TWZJ5RC70VY1HG8	usd	f	store_01KYYM111TEF1TB5WREKE1SRKQ	2026-08-03 23:19:46.353463+00	2026-08-03 23:19:46.353463+00	\N
\.


--
-- Data for Name: store_locale; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.store_locale (id, locale_code, store_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2026-08-01 12:14:52.46+00	2026-08-01 12:14:52.46+00	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01KYYM11EFDXXMZSTRH7DQZRFP	tp_system	gb	\N	\N	\N	2026-08-01 12:15:50.229+00	2026-08-01 12:15:50.229+00	\N	\N
txreg_01KYYM11EGPZV9K906DQNVRPD4	tp_system	de	\N	\N	\N	2026-08-01 12:15:50.23+00	2026-08-01 12:15:50.23+00	\N	\N
txreg_01KYYM11EH0TPSBBC7X4ZAR507	tp_system	dk	\N	\N	\N	2026-08-01 12:15:50.23+00	2026-08-01 12:15:50.23+00	\N	\N
txreg_01KYYM11EHCPR0JKHTEGCQAZC9	tp_system	se	\N	\N	\N	2026-08-01 12:15:50.231+00	2026-08-01 12:15:50.231+00	\N	\N
txreg_01KYYM11EJ3MT9ERVCE6NMYWW9	tp_system	fr	\N	\N	\N	2026-08-01 12:15:50.231+00	2026-08-01 12:15:50.231+00	\N	\N
txreg_01KYYM11EK7SQVSCBT3DRPE6SD	tp_system	es	\N	\N	\N	2026-08-01 12:15:50.231+00	2026-08-01 12:15:50.231+00	\N	\N
txreg_01KYYM11EKHW6CH9BMERHYBAMX	tp_system	it	\N	\N	\N	2026-08-01 12:15:50.231+00	2026-08-01 12:15:50.231+00	\N	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01KYYNKVJ36N15NC6JETPYNX29	Divansh	Singh	admin@test.com	\N	\N	2026-08-01 12:43:35.374+00	2026-08-03 22:45:18.337+00	\N
\.


--
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.user_preference (id, user_id, key, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: user_rbac_role; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.user_rbac_role (user_id, rbac_role_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: view_configuration; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.view_configuration (id, entity, name, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: strawb-user
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 40, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 177, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, false);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: strawb-user
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 6, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: auth_mfa_factor auth_mfa_factor_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_mfa_factor
    ADD CONSTRAINT auth_mfa_factor_pkey PRIMARY KEY (id);


--
-- Name: auth_mfa_recovery_code auth_mfa_recovery_code_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_mfa_recovery_code
    ADD CONSTRAINT auth_mfa_recovery_code_pkey PRIMARY KEY (id);


--
-- Name: auth_password_reset_token auth_password_reset_token_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_password_reset_token
    ADD CONSTRAINT auth_password_reset_token_pkey PRIMARY KEY (id);


--
-- Name: auth_verification auth_verification_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_verification
    ADD CONSTRAINT auth_verification_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: content_collection content_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_collection
    ADD CONSTRAINT content_collection_pkey PRIMARY KEY (id);


--
-- Name: content_creator_activity content_creator_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_creator_activity
    ADD CONSTRAINT content_creator_activity_pkey PRIMARY KEY (id);


--
-- Name: content_creator content_creator_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_creator
    ADD CONSTRAINT content_creator_pkey PRIMARY KEY (id);


--
-- Name: content_field content_field_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_field
    ADD CONSTRAINT content_field_pkey PRIMARY KEY (id);


--
-- Name: content_item_activity content_item_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_item_activity
    ADD CONSTRAINT content_item_activity_pkey PRIMARY KEY (id);


--
-- Name: content_item content_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_item
    ADD CONSTRAINT content_item_pkey PRIMARY KEY (id);


--
-- Name: content_link content_link_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_link
    ADD CONSTRAINT content_link_pkey PRIMARY KEY (id);


--
-- Name: content_relationship content_relationship_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_relationship
    ADD CONSTRAINT content_relationship_pkey PRIMARY KEY (id);


--
-- Name: content_tag content_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_tag
    ADD CONSTRAINT content_tag_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_activity customer_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_activity
    ADD CONSTRAINT customer_activity_pkey PRIMARY KEY (id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: invite_rbac_role invite_rbac_role_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.invite_rbac_role
    ADD CONSTRAINT invite_rbac_role_pkey PRIMARY KEY (invite_id, rbac_role_id);


--
-- Name: layout_configuration layout_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.layout_configuration
    ADD CONSTRAINT layout_configuration_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_product_option product_product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_product_option
    ADD CONSTRAINT product_product_option_pkey PRIMARY KEY (id);


--
-- Name: product_product_option_value product_product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_product_option_value
    ADD CONSTRAINT product_product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: product_variant_product_image product_variant_product_image_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_product_image
    ADD CONSTRAINT product_variant_product_image_pkey PRIMARY KEY (id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: property_label property_label_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.property_label
    ADD CONSTRAINT property_label_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store_locale store_locale_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.store_locale
    ADD CONSTRAINT store_locale_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (id);


--
-- Name: user_rbac_role user_rbac_role_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.user_rbac_role
    ADD CONSTRAINT user_rbac_role_pkey PRIMARY KEY (user_id, rbac_role_id);


--
-- Name: view_configuration view_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.view_configuration
    ADD CONSTRAINT view_configuration_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_redacted; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_api_key_redacted" ON public.api_key USING btree (redacted) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_revoked_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_api_key_revoked_at" ON public.api_key USING btree (revoked_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_mfa_factor_auth_identity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_mfa_factor_auth_identity_id" ON public.auth_mfa_factor USING btree (auth_identity_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_mfa_factor_auth_identity_provider_active; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_auth_mfa_factor_auth_identity_provider_active" ON public.auth_mfa_factor USING btree (auth_identity_id, provider) WHERE ((deleted_at IS NULL) AND (status = ANY (ARRAY['pending'::text, 'enabled'::text])));


--
-- Name: IDX_auth_mfa_factor_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_mfa_factor_deleted_at" ON public.auth_mfa_factor USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_mfa_recovery_code_auth_identity_code_hash; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_auth_mfa_recovery_code_auth_identity_code_hash" ON public.auth_mfa_recovery_code USING btree (auth_identity_id, code_hash) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_mfa_recovery_code_auth_identity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_mfa_recovery_code_auth_identity_id" ON public.auth_mfa_recovery_code USING btree (auth_identity_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_mfa_recovery_code_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_mfa_recovery_code_deleted_at" ON public.auth_mfa_recovery_code USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_password_reset_token_auth_identity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_password_reset_token_auth_identity_id" ON public.auth_password_reset_token USING btree (auth_identity_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_password_reset_token_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_password_reset_token_deleted_at" ON public.auth_password_reset_token USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_password_reset_token_expires_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_password_reset_token_expires_at" ON public.auth_password_reset_token USING btree (expires_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_password_reset_token_provider_identity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_password_reset_token_provider_identity_id" ON public.auth_password_reset_token USING btree (provider_identity_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_password_reset_token_token_hash; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_password_reset_token_token_hash" ON public.auth_password_reset_token USING btree (token_hash) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_verification_auth_identity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_verification_auth_identity_id" ON public.auth_verification USING btree (auth_identity_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_verification_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_auth_verification_deleted_at" ON public.auth_verification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_auth_verification_unique_auth_identity_entity_id_entity_typ; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_auth_verification_unique_auth_identity_entity_id_entity_typ" ON public.auth_verification USING btree (auth_identity_id, entity_id, entity_type) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_collection_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_collection_deleted_at" ON public.content_collection USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_collection_slug_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_content_collection_slug_unique" ON public.content_collection USING btree (slug) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_creator_activity_creator_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_creator_activity_creator_id" ON public.content_creator_activity USING btree (creator_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_creator_activity_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_creator_activity_deleted_at" ON public.content_creator_activity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_creator_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_creator_deleted_at" ON public.content_creator USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_field_content_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_field_content_collection_id" ON public.content_field USING btree (content_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_field_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_field_deleted_at" ON public.content_field USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_item_activity_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_item_activity_deleted_at" ON public.content_item_activity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_item_activity_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_item_activity_item_id" ON public.content_item_activity USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_item_content_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_item_content_collection_id" ON public.content_item USING btree (content_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_item_creator_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_item_creator_id" ON public.content_item USING btree (creator_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_item_deleted_at" ON public.content_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_link_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_link_deleted_at" ON public.content_link USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_link_relationship_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_link_relationship_id" ON public.content_link USING btree (relationship_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_link_source_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_link_source_item_id" ON public.content_link USING btree (source_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_link_target_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_link_target_item_id" ON public.content_link USING btree (target_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_relationship_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_relationship_deleted_at" ON public.content_relationship USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_relationship_source_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_relationship_source_collection_id" ON public.content_relationship USING btree (source_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_relationship_target_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_relationship_target_collection_id" ON public.content_relationship USING btree (target_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_tag_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_tag_deleted_at" ON public.content_tag USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_content_tag_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_content_tag_item_id" ON public.content_tag USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_activity_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_activity_deleted_at" ON public.customer_activity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-85069d44; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-85069d44" ON public.invite_rbac_role USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_64ff0c4c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_64ff0c4c" ON public.user_rbac_role USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-85069d44; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-85069d44" ON public.invite_rbac_role USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_64ff0c4c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_64ff0c4c" ON public.user_rbac_role USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_id_-85069d44; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_invite_id_-85069d44" ON public.invite_rbac_role USING btree (invite_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_layout_configuration_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_layout_configuration_deleted_at" ON public.layout_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_layout_configuration_zone_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_layout_configuration_zone_unique" ON public.layout_configuration USING btree (zone) WHERE ((is_system_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_layout_configuration_zone_user_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_layout_configuration_zone_user_id_unique" ON public.layout_configuration USING btree (zone, user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.order_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_change_version" ON public.order_change USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_credit_line_order_id_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_credit_line_order_id_version" ON public.order_credit_line USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_custom_display_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_order_custom_display_id" ON public."order" USING btree (custom_display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_sales_channel_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_sales_channel_id" ON public."order" USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_version_shipping_method; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_order_shipping_method_adjustment_version_shipping_method" ON public.order_shipping_method_adjustment USING btree (version, shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_shipping_method_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_shipping_shipping_method_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_order_id" ON public.order_transaction USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_id_status_starts_at_ends_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_list_id_status_starts_at_ends_at" ON public.price_list USING btree (id, status, starts_at, ends_at) WHERE ((deleted_at IS NULL) AND (status = 'active'::text));


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_list_rule_value" ON public.price_list_rule USING gin (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value_price_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_attribute_value_price_id" ON public.price_rule USING btree (attribute, value, price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_image_rank" ON public.image USING btree (rank) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_rank_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_image_rank_product_id" ON public.image USING btree (rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_image_url_rank_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_image_url_rank_product_id" ON public.image USING btree (url, rank, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_global_title_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_product_option_global_title_unique" ON public.product_option USING btree (title) WHERE ((deleted_at IS NULL) AND (is_exclusive = false));


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_product_option_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_product_option_deleted_at" ON public.product_product_option USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_product_option_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_product_option_product_id" ON public.product_product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_product_option_product_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_product_option_product_option_id" ON public.product_product_option USING btree (product_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_product_option_value_deleted_at" ON public.product_product_option_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_product_option_value_product_option_value_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_product_option_value_product_option_value_id" ON public.product_product_option_value USING btree (product_option_value_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_product_option_value_product_product_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_product_option_value_product_product_option_id" ON public.product_product_option_value USING btree (product_product_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_status; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_status" ON public.product USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_image_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_variant_product_image_deleted_at" ON public.product_variant_product_image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_image_image_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_variant_product_image_image_id" ON public.product_variant_product_image USING btree (image_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_image_variant_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_product_variant_product_image_variant_id" ON public.product_variant_product_image USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_usage_attribute_value_budget_id_u" ON public.promotion_campaign_budget_usage USING btree (attribute_value, budget_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_budget_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_budget_id" ON public.promotion_campaign_budget_usage USING btree (budget_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_usage_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_campaign_budget_usage_deleted_at" ON public.promotion_campaign_budget_usage USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_is_automatic; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_is_automatic" ON public.promotion USING btree (is_automatic) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_attribute_operator; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_attribute_operator" ON public.promotion_rule USING btree (attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_attribute_operator_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_attribute_operator_id" ON public.promotion_rule USING btree (operator, attribute, id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_rule_id_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_value_rule_id_value" ON public.promotion_rule_value USING btree (promotion_rule_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_rule_value_value" ON public.promotion_rule_value USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_property_label_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_property_label_deleted_at" ON public.property_label USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_property_label_entity; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_property_label_entity" ON public.property_label USING btree (entity) WHERE (deleted_at IS NULL);


--
-- Name: IDX_property_label_entity_property_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_property_label_entity_property_unique" ON public.property_label USING btree (entity, property) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_rbac_role_id_-85069d44; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_rbac_role_id_-85069d44" ON public.invite_rbac_role USING btree (rbac_role_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_rbac_role_id_64ff0c4c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_rbac_role_id_64ff0c4c" ON public.user_rbac_role USING btree (rbac_role_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_parent_return_reason_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_reason_parent_return_reason_id" ON public.return_reason USING btree (parent_return_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_option_type_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_shipping_option_type_id" ON public.shipping_option USING btree (shipping_option_type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_locale_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_store_locale_deleted_at" ON public.store_locale USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_locale_store_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_store_locale_store_id" ON public.store_locale USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_id_64ff0c4c; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_user_id_64ff0c4c" ON public.user_rbac_role USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_user_preference_deleted_at" ON public.user_preference USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_user_preference_user_id" ON public.user_preference USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id_key_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_user_preference_user_id_key_unique" ON public.user_preference USING btree (user_id, key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_view_configuration_deleted_at" ON public.view_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_is_system_default; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_view_configuration_entity_is_system_default" ON public.view_configuration USING btree (entity, is_system_default) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_user_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_view_configuration_entity_user_id" ON public.view_configuration USING btree (entity, user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_user_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_view_configuration_user_id" ON public.view_configuration USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_retention_time_updated_at_state; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_retention_time_updated_at_state" ON public.workflow_execution USING btree (retention_time, updated_at, state) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL));


--
-- Name: IDX_workflow_execution_run_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_run_id" ON public.workflow_execution USING btree (run_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state_updated_at; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_state_updated_at" ON public.workflow_execution USING btree (state, updated_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_updated_at_retention_time; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_updated_at_retention_time" ON public.workflow_execution USING btree (updated_at, retention_time) WHERE ((deleted_at IS NULL) AND (retention_time IS NOT NULL) AND ((state)::text = ANY ((ARRAY['done'::character varying, 'failed'::character varying, 'reverted'::character varying])::text[])));


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE INDEX "IDX_workflow_execution_workflow_id_transaction_id" ON public.workflow_execution USING btree (workflow_id, transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: strawb-user
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_mfa_factor auth_mfa_factor_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_mfa_factor
    ADD CONSTRAINT auth_mfa_factor_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_mfa_recovery_code auth_mfa_recovery_code_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_mfa_recovery_code
    ADD CONSTRAINT auth_mfa_recovery_code_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_password_reset_token auth_password_reset_token_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_password_reset_token
    ADD CONSTRAINT auth_password_reset_token_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_password_reset_token auth_password_reset_token_provider_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_password_reset_token
    ADD CONSTRAINT auth_password_reset_token_provider_identity_id_foreign FOREIGN KEY (provider_identity_id) REFERENCES public.provider_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auth_verification auth_verification_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.auth_verification
    ADD CONSTRAINT auth_verification_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_creator_activity content_creator_activity_creator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_creator_activity
    ADD CONSTRAINT content_creator_activity_creator_id_foreign FOREIGN KEY (creator_id) REFERENCES public.content_creator(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_field content_field_content_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_field
    ADD CONSTRAINT content_field_content_collection_id_foreign FOREIGN KEY (content_collection_id) REFERENCES public.content_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_item_activity content_item_activity_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_item_activity
    ADD CONSTRAINT content_item_activity_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.content_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_item content_item_content_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_item
    ADD CONSTRAINT content_item_content_collection_id_foreign FOREIGN KEY (content_collection_id) REFERENCES public.content_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_item content_item_creator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_item
    ADD CONSTRAINT content_item_creator_id_foreign FOREIGN KEY (creator_id) REFERENCES public.content_creator(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: content_link content_link_relationship_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_link
    ADD CONSTRAINT content_link_relationship_id_foreign FOREIGN KEY (relationship_id) REFERENCES public.content_relationship(id) ON UPDATE CASCADE;


--
-- Name: content_link content_link_source_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_link
    ADD CONSTRAINT content_link_source_item_id_foreign FOREIGN KEY (source_item_id) REFERENCES public.content_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_link content_link_target_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_link
    ADD CONSTRAINT content_link_target_item_id_foreign FOREIGN KEY (target_item_id) REFERENCES public.content_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_relationship content_relationship_source_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_relationship
    ADD CONSTRAINT content_relationship_source_collection_id_foreign FOREIGN KEY (source_collection_id) REFERENCES public.content_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_relationship content_relationship_target_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_relationship
    ADD CONSTRAINT content_relationship_target_collection_id_foreign FOREIGN KEY (target_collection_id) REFERENCES public.content_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_tag content_tag_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.content_tag
    ADD CONSTRAINT content_tag_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.content_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_product_option product_product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_product_option
    ADD CONSTRAINT product_product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_product_option product_product_option_product_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_product_option
    ADD CONSTRAINT product_product_option_product_option_id_foreign FOREIGN KEY (product_option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_product_option_value product_product_option_value_product_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_product_option_value
    ADD CONSTRAINT product_product_option_value_product_option_value_id_foreign FOREIGN KEY (product_option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_product_option_value product_product_option_value_product_product_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_product_option_value
    ADD CONSTRAINT product_product_option_value_product_product_option_id_foreign FOREIGN KEY (product_product_option_id) REFERENCES public.product_product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_product_image product_variant_product_image_image_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.product_variant_product_image
    ADD CONSTRAINT product_variant_product_image_image_id_foreign FOREIGN KEY (image_id) REFERENCES public.image(id) ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget_usage promotion_campaign_budget_usage_budget_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_campaign_budget_usage
    ADD CONSTRAINT promotion_campaign_budget_usage_budget_id_foreign FOREIGN KEY (budget_id) REFERENCES public.promotion_campaign_budget(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_locale store_locale_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: strawb-user
--

ALTER TABLE ONLY public.store_locale
    ADD CONSTRAINT store_locale_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict w0CmFSg8LdAypyDNdqRATU6yclVW0ssFzt2F73mZ1ZzB68rKrM9fyX0QezGae39

