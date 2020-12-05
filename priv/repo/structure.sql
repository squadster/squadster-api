--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.5 (Ubuntu 12.5-0ubuntu0.20.04.1)

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
-- Name: lessons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lessons (
    id bigint NOT NULL,
    name character varying(255),
    teacher character varying(255),
    index integer,
    note character varying(255),
    timetable_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    classroom character varying(255),
    type character varying(255)
);


--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lessons_id_seq OWNED BY public.lessons.id;


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
    updated_at timestamp(0) without time zone NOT NULL,
    link_invitations_enabled boolean DEFAULT true,
    hash_id character varying(255)
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
-- Name: timetables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timetables (
    id bigint NOT NULL,
    date date,
    squad_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: timetables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timetables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timetables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timetables_id_seq OWNED BY public.timetables.id;


--
-- Name: user_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_configurations (
    id bigint NOT NULL,
    speaker character varying(255),
    language character varying(255),
    rate character varying(255),
    enable_voice_messages boolean,
    user_id bigint
);


--
-- Name: user_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_configurations_id_seq OWNED BY public.user_configurations.id;


--
-- Name: user_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_settings (
    id bigint NOT NULL,
    vk_notifications_enabled boolean DEFAULT true,
    telegram_notifications_enabled boolean DEFAULT false,
    email_notifications_enabled boolean DEFAULT false,
    user_id bigint
);


--
-- Name: user_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_settings_id_seq OWNED BY public.user_settings.id;


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
    updated_at timestamp(0) without time zone NOT NULL,
    hash_id character varying(255),
    telegram_chat_id bigint,
    telegram_id integer,
    telegram_token character varying(255)
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
-- Name: lessons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lessons ALTER COLUMN id SET DEFAULT nextval('public.lessons_id_seq'::regclass);


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
-- Name: timetables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetables ALTER COLUMN id SET DEFAULT nextval('public.timetables_id_seq'::regclass);


--
-- Name: user_configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_configurations ALTER COLUMN id SET DEFAULT nextval('public.user_configurations_id_seq'::regclass);


--
-- Name: user_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_settings ALTER COLUMN id SET DEFAULT nextval('public.user_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


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
-- Name: timetables timetables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_pkey PRIMARY KEY (id);


--
-- Name: user_configurations user_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_configurations
    ADD CONSTRAINT user_configurations_pkey PRIMARY KEY (id);


--
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_pkey PRIMARY KEY (id);


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
-- Name: squads_hash_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX squads_hash_id_index ON public.squads USING btree (hash_id);


--
-- Name: users_hash_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_hash_id_index ON public.users USING btree (hash_id);


--
-- Name: users_telegram_chat_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_telegram_chat_id_index ON public.users USING btree (telegram_chat_id);


--
-- Name: lessons lessons_timetable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_timetable_id_fkey FOREIGN KEY (timetable_id) REFERENCES public.timetables(id) ON DELETE CASCADE;


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
-- Name: timetables timetables_squad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timetables
    ADD CONSTRAINT timetables_squad_id_fkey FOREIGN KEY (squad_id) REFERENCES public.squads(id) ON DELETE CASCADE;


--
-- Name: user_configurations user_configurations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_configurations
    ADD CONSTRAINT user_configurations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20190630112212);
INSERT INTO public."schema_migrations" (version) VALUES (20200213154100);
INSERT INTO public."schema_migrations" (version) VALUES (20200213154344);
INSERT INTO public."schema_migrations" (version) VALUES (20200219194502);
INSERT INTO public."schema_migrations" (version) VALUES (20200618212702);
INSERT INTO public."schema_migrations" (version) VALUES (20200711235358);
INSERT INTO public."schema_migrations" (version) VALUES (20200712000103);
INSERT INTO public."schema_migrations" (version) VALUES (20201008171100);
INSERT INTO public."schema_migrations" (version) VALUES (20201009202124);
INSERT INTO public."schema_migrations" (version) VALUES (20201112204057);
INSERT INTO public."schema_migrations" (version) VALUES (20201120215642);
INSERT INTO public."schema_migrations" (version) VALUES (20201121230145);
INSERT INTO public."schema_migrations" (version) VALUES (20201203174319);
INSERT INTO public."schema_migrations" (version) VALUES (20201205205445);
