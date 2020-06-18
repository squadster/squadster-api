--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12 (Ubuntu 10.12-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-2.pgdg16.04+1)

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

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: squad_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.squad_members (
    id bigint NOT NULL,
    role integer DEFAULT 3,
    queue_number integer,
    user_id bigint,
    squad_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: squad_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.squad_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: squad_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.squad_members_id_seq OWNED BY public.squad_members.id;


--
-- Name: squad_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.squad_requests (
    id bigint NOT NULL,
    approver_id bigint,
    user_id bigint,
    squad_id bigint,
    approved_at timestamp without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: squad_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.squad_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: squad_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.squad_requests_id_seq OWNED BY public.squad_requests.id;


--
-- Name: squads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.squads (
    id bigint NOT NULL,
    squad_number character varying(255),
    advertisment text,
    class_day integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: squads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.squads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: squads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.squads_id_seq OWNED BY public.squads.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    uid character varying(255),
    auth_token character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    birth_date date,
    mobile_phone character varying(255),
    university character varying(255),
    faculty character varying(255),
    small_image_url character varying(255),
    image_url character varying(255),
    vk_url character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: squad_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_members ALTER COLUMN id SET DEFAULT nextval('public.squad_members_id_seq'::regclass);


--
-- Name: squad_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_requests ALTER COLUMN id SET DEFAULT nextval('public.squad_requests_id_seq'::regclass);


--
-- Name: squads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squads ALTER COLUMN id SET DEFAULT nextval('public.squads_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: squad_members squad_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_members
    ADD CONSTRAINT squad_members_pkey PRIMARY KEY (id);


--
-- Name: squad_requests squad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_requests
    ADD CONSTRAINT squad_requests_pkey PRIMARY KEY (id);


--
-- Name: squads squads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squads
    ADD CONSTRAINT squads_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: squad_members_squad_id_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX squad_members_squad_id_user_id_index ON public.squad_members USING btree (squad_id, user_id);


--
-- Name: squad_requests_squad_id_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX squad_requests_squad_id_user_id_index ON public.squad_requests USING btree (squad_id, user_id);


--
-- Name: squad_members squad_members_squad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_members
    ADD CONSTRAINT squad_members_squad_id_fkey FOREIGN KEY (squad_id) REFERENCES public.squads(id);


--
-- Name: squad_members squad_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_members
    ADD CONSTRAINT squad_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: squad_requests squad_requests_approver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_requests
    ADD CONSTRAINT squad_requests_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.squad_members(id) ON DELETE SET NULL;


--
-- Name: squad_requests squad_requests_squad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_requests
    ADD CONSTRAINT squad_requests_squad_id_fkey FOREIGN KEY (squad_id) REFERENCES public.squads(id) ON DELETE CASCADE;


--
-- Name: squad_requests squad_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.squad_requests
    ADD CONSTRAINT squad_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20190630112212), (20200213154100), (20200213154344), (20200219194502), (20200618212702);

