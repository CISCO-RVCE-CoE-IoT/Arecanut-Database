--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    admin_id integer NOT NULL,
    admin_fname character varying NOT NULL,
    admin_lname character varying,
    admin_password character varying NOT NULL,
    admin_phone character varying,
    admin_email character varying NOT NULL,
    join_date date DEFAULT CURRENT_DATE,
    admin_location character varying,
    admin_session_key character varying DEFAULT 0
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_admin_id_seq OWNER TO postgres;

--
-- Name: admin_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_admin_id_seq OWNED BY public.admin.admin_id;


--
-- Name: farm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farm (
    farm_id integer NOT NULL,
    farm_name character varying NOT NULL,
    creation_date date DEFAULT CURRENT_DATE,
    farmer_id integer,
    farm_size real,
    farm_location_cordinates character varying[],
    auto_on_threshold integer DEFAULT 30 NOT NULL,
    auto_off_threshold integer DEFAULT 70 NOT NULL,
    farm_key character varying DEFAULT 'farm_key'::character varying NOT NULL
);


ALTER TABLE public.farm OWNER TO postgres;

--
-- Name: farm_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farm_devices (
    farm_device_id integer NOT NULL,
    farm_id integer,
    device_name character varying,
    device_location character varying,
    installation_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.farm_devices OWNER TO postgres;

--
-- Name: farmer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farmer (
    farmer_id integer NOT NULL,
    farmer_fname character varying NOT NULL,
    farmer_lname character varying,
    farmer_password character varying NOT NULL,
    farmer_phone character varying,
    farmer_email character varying NOT NULL,
    join_date date DEFAULT CURRENT_DATE,
    admin_id integer,
    farmer_session_key character varying DEFAULT 0
);


ALTER TABLE public.farmer OWNER TO postgres;

--
-- Name: field_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.field_data (
    field_data_id integer NOT NULL,
    farm_device_id integer,
    nitrogen double precision,
    phosphorus double precision,
    potassium double precision,
    temperature double precision,
    humidity double precision,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.field_data OWNER TO postgres;

--
-- Name: all_field_data; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_field_data AS
 SELECT fd.field_data_id,
    fd.farm_device_id,
    fd.nitrogen,
    fd.phosphorus,
    fd.potassium,
    fd.temperature,
    fd.humidity,
    fd."timestamp",
    f.farm_id,
    fr.farmer_id,
    fr.farmer_session_key
   FROM (((public.field_data fd
     JOIN public.farm_devices fdv ON ((fd.farm_device_id = fdv.farm_device_id)))
     JOIN public.farm f ON ((fdv.farm_id = f.farm_id)))
     JOIN public.farmer fr ON ((f.farmer_id = fr.farmer_id)));


ALTER VIEW public.all_field_data OWNER TO postgres;

--
-- Name: moisture_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moisture_data (
    moisture_data_id integer NOT NULL,
    section_device_id integer,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    moisture_value double precision
);


ALTER TABLE public.moisture_data OWNER TO postgres;

--
-- Name: section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.section (
    section_id integer NOT NULL,
    farm_id integer,
    creation_date date DEFAULT CURRENT_DATE,
    section_name character varying DEFAULT 'section_name'::character varying
);


ALTER TABLE public.section OWNER TO postgres;

--
-- Name: section_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.section_devices (
    section_device_id integer NOT NULL,
    section_id integer,
    device_name character varying,
    device_location character varying,
    installation_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.section_devices OWNER TO postgres;

--
-- Name: all_moisture_data; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_moisture_data AS
 SELECT md.moisture_data_id,
    md.section_device_id,
    md."timestamp",
    md.moisture_value,
    s.section_id,
    f.farm_id,
    fr.farmer_id,
    fr.farmer_session_key
   FROM ((((public.moisture_data md
     JOIN public.section_devices sd ON ((md.section_device_id = sd.section_device_id)))
     JOIN public.section s ON ((sd.section_id = s.section_id)))
     JOIN public.farm f ON ((s.farm_id = f.farm_id)))
     JOIN public.farmer fr ON ((f.farmer_id = fr.farmer_id)));


ALTER VIEW public.all_moisture_data OWNER TO postgres;

--
-- Name: valve_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.valve_data (
    valve_data_id integer NOT NULL,
    section_device_id integer,
    valve_mode character varying,
    valve_status character varying,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    manual_off_timer integer DEFAULT 0
);


ALTER TABLE public.valve_data OWNER TO postgres;

--
-- Name: all_valve_data; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_valve_data AS
 SELECT vd.valve_data_id,
    vd.section_device_id,
    vd.valve_mode,
    vd.valve_status,
    vd."timestamp",
    vd.manual_off_timer,
    s.section_id,
    f.farm_id,
    fr.farmer_id,
    fr.farmer_session_key
   FROM ((((public.valve_data vd
     JOIN public.section_devices sd ON ((vd.section_device_id = sd.section_device_id)))
     JOIN public.section s ON ((sd.section_id = s.section_id)))
     JOIN public.farm f ON ((s.farm_id = f.farm_id)))
     JOIN public.farmer fr ON ((f.farmer_id = fr.farmer_id)));


ALTER VIEW public.all_valve_data OWNER TO postgres;

--
-- Name: devices_device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.devices_device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.devices_device_id_seq OWNER TO postgres;

--
-- Name: devices_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.devices_device_id_seq OWNED BY public.section_devices.section_device_id;


--
-- Name: farm_devices_device_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farm_devices_device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.farm_devices_device_id_seq OWNER TO postgres;

--
-- Name: farm_devices_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farm_devices_device_id_seq OWNED BY public.farm_devices.farm_device_id;


--
-- Name: farm_farm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farm_farm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.farm_farm_id_seq OWNER TO postgres;

--
-- Name: farm_farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farm_farm_id_seq OWNED BY public.farm.farm_id;


--
-- Name: farm_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farm_log (
    farm_log_id integer NOT NULL,
    farm_id integer,
    description character varying NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.farm_log OWNER TO postgres;

--
-- Name: farm_log_farm_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farm_log_farm_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.farm_log_farm_log_id_seq OWNER TO postgres;

--
-- Name: farm_log_farm_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farm_log_farm_log_id_seq OWNED BY public.farm_log.farm_log_id;


--
-- Name: farm_with_all_devices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.farm_with_all_devices AS
 SELECT f.farm_id,
    f.farm_key,
    s.section_id,
    sd.section_device_id,
    sd.device_name AS section_device_name
   FROM ((public.farm f
     JOIN public.section s ON ((f.farm_id = s.farm_id)))
     JOIN public.section_devices sd ON ((s.section_id = sd.section_id)));


ALTER VIEW public.farm_with_all_devices OWNER TO postgres;

--
-- Name: farmer_farm_with_all_section_devices; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.farmer_farm_with_all_section_devices AS
 SELECT fr.admin_id,
    fr.farmer_id,
    f.farm_id,
    s.section_id,
    sd.section_device_id,
    sd.device_name,
    sd.device_location,
    sd.installation_date
   FROM (((public.farmer fr
     JOIN public.farm f ON ((fr.farmer_id = f.farmer_id)))
     JOIN public.section s ON ((f.farm_id = s.farm_id)))
     JOIN public.section_devices sd ON ((s.section_id = sd.section_id)));


ALTER VIEW public.farmer_farm_with_all_section_devices OWNER TO postgres;

--
-- Name: farmer_farm_with_sections; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.farmer_farm_with_sections AS
 SELECT fr.admin_id,
    fr.farmer_id,
    f.farm_id,
    s.section_id,
    s.creation_date,
    s.section_name,
    count(sd.section_device_id) AS total_section_devices
   FROM (((public.farmer fr
     JOIN public.farm f ON ((fr.farmer_id = f.farmer_id)))
     JOIN public.section s ON ((f.farm_id = s.farm_id)))
     JOIN public.section_devices sd ON ((s.section_id = sd.section_id)))
  GROUP BY s.section_id, fr.admin_id, fr.farmer_id, f.farm_id, s.creation_date, s.section_name;


ALTER VIEW public.farmer_farm_with_sections OWNER TO postgres;

--
-- Name: farmer_farmer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farmer_farmer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.farmer_farmer_id_seq OWNER TO postgres;

--
-- Name: farmer_farmer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farmer_farmer_id_seq OWNED BY public.farmer.farmer_id;


--
-- Name: field_data_field_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.field_data_field_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.field_data_field_data_id_seq OWNER TO postgres;

--
-- Name: field_data_field_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.field_data_field_data_id_seq OWNED BY public.field_data.field_data_id;


--
-- Name: lst_valve_avg_moisture; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lst_valve_avg_moisture AS
 WITH latestmoisture AS (
         SELECT md.section_device_id,
            md.moisture_value
           FROM (public.moisture_data md
             JOIN ( SELECT moisture_data.section_device_id,
                    max(moisture_data.moisture_data_id) AS max_moisture_data_id
                   FROM public.moisture_data
                  GROUP BY moisture_data.section_device_id) latest_md ON (((md.section_device_id = latest_md.section_device_id) AND (md.moisture_data_id = latest_md.max_moisture_data_id))))
        ), sectionavgmoisture AS (
         SELECT sd_1.section_id,
            avg(lm.moisture_value) AS avg_section_moisture
           FROM (latestmoisture lm
             JOIN public.section_devices sd_1 ON ((lm.section_device_id = sd_1.section_device_id)))
          GROUP BY sd_1.section_id
        ), latestvalvedata AS (
         SELECT vd.section_device_id,
            vd.valve_data_id,
            vd."timestamp" AS valve_timestamp,
            vd.valve_mode,
            vd.valve_status,
            vd.manual_off_timer
           FROM (public.valve_data vd
             JOIN ( SELECT valve_data.section_device_id,
                    max(valve_data.valve_data_id) AS max_valve_data_id
                   FROM public.valve_data
                  GROUP BY valve_data.section_device_id) latest_vd ON (((vd.section_device_id = latest_vd.section_device_id) AND (vd.valve_data_id = latest_vd.max_valve_data_id))))
        )
 SELECT lvd.valve_data_id,
    lvd.valve_timestamp,
    lvd.valve_mode,
    lvd.valve_status,
    lvd.manual_off_timer,
    sd.section_device_id,
    s.section_id,
    s.section_name,
    f.farm_id,
    f.auto_on_threshold,
    f.auto_off_threshold,
    fr.farmer_id,
    sam.avg_section_moisture,
    fr.farmer_session_key,
    f.farm_key
   FROM (((((latestvalvedata lvd
     JOIN public.section_devices sd ON ((lvd.section_device_id = sd.section_device_id)))
     JOIN public.section s ON ((sd.section_id = s.section_id)))
     JOIN public.farm f ON ((s.farm_id = f.farm_id)))
     JOIN public.farmer fr ON ((f.farmer_id = fr.farmer_id)))
     LEFT JOIN sectionavgmoisture sam ON ((s.section_id = sam.section_id)));


ALTER VIEW public.lst_valve_avg_moisture OWNER TO postgres;

--
-- Name: lst_field_data; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lst_field_data AS
 WITH latest_data AS (
         SELECT DISTINCT ON (fd.farm_device_id) fd.field_data_id,
            fd.farm_device_id,
            fd.nitrogen,
            fd.phosphorus,
            fd.potassium,
            fd.temperature,
            fd.humidity,
            fd."timestamp",
            f.farm_id,
            fr.farmer_id,
            fr.farmer_session_key
           FROM (((public.field_data fd
             JOIN public.farm_devices fdv ON ((fd.farm_device_id = fdv.farm_device_id)))
             JOIN public.farm f ON ((fdv.farm_id = f.farm_id)))
             JOIN public.farmer fr ON ((f.farmer_id = fr.farmer_id)))
          ORDER BY fd.farm_device_id, fd."timestamp" DESC
        ), avg_moisture AS (
         SELECT lst_valve_avg_moisture.farm_id,
            avg(lst_valve_avg_moisture.avg_section_moisture) AS avg_moisture
           FROM public.lst_valve_avg_moisture
          GROUP BY lst_valve_avg_moisture.farm_id
        )
 SELECT ld.field_data_id,
    ld.farm_device_id,
    ld.nitrogen,
    ld.phosphorus,
    ld.potassium,
    ld.temperature,
    ld.humidity,
    ld."timestamp",
    ld.farm_id,
    ld.farmer_id,
    avg_moisture.avg_moisture,
    ld.farmer_session_key
   FROM (latest_data ld
     LEFT JOIN avg_moisture ON ((ld.farm_id = avg_moisture.farm_id)));


ALTER VIEW public.lst_field_data OWNER TO postgres;

--
-- Name: lst_section_avg_moisture; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lst_section_avg_moisture AS
 WITH latestmoisture AS (
         SELECT md.section_device_id,
            md.moisture_value
           FROM (public.moisture_data md
             JOIN ( SELECT moisture_data.section_device_id,
                    max(moisture_data.moisture_data_id) AS max_moisture_data_id
                   FROM public.moisture_data
                  GROUP BY moisture_data.section_device_id) latest_md ON (((md.section_device_id = latest_md.section_device_id) AND (md.moisture_data_id = latest_md.max_moisture_data_id))))
        ), sectionavgmoisture AS (
         SELECT sd.section_id,
            avg(lm.moisture_value) AS avg_section_moisture
           FROM (latestmoisture lm
             JOIN public.section_devices sd ON ((lm.section_device_id = sd.section_device_id)))
          GROUP BY sd.section_id
        )
 SELECT s.section_id,
    s.section_name,
    f.farm_id,
    fr.farmer_id,
    sam.avg_section_moisture,
    fr.farmer_session_key
   FROM (((public.section s
     JOIN public.farm f ON ((s.farm_id = f.farm_id)))
     JOIN public.farmer fr ON ((f.farmer_id = fr.farmer_id)))
     LEFT JOIN sectionavgmoisture sam ON ((s.section_id = sam.section_id)));


ALTER VIEW public.lst_section_avg_moisture OWNER TO postgres;

--
-- Name: moisture_data_moisture_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.moisture_data_moisture_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.moisture_data_moisture_data_id_seq OWNER TO postgres;

--
-- Name: moisture_data_moisture_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.moisture_data_moisture_data_id_seq OWNED BY public.moisture_data.moisture_data_id;


--
-- Name: section_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.section_section_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.section_section_id_seq OWNER TO postgres;

--
-- Name: section_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.section_section_id_seq OWNED BY public.section.section_id;


--
-- Name: valve_data_valve_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.valve_data_valve_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.valve_data_valve_data_id_seq OWNER TO postgres;

--
-- Name: valve_data_valve_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.valve_data_valve_data_id_seq OWNED BY public.valve_data.valve_data_id;


--
-- Name: admin admin_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN admin_id SET DEFAULT nextval('public.admin_admin_id_seq'::regclass);


--
-- Name: farm farm_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm ALTER COLUMN farm_id SET DEFAULT nextval('public.farm_farm_id_seq'::regclass);


--
-- Name: farm_devices farm_device_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm_devices ALTER COLUMN farm_device_id SET DEFAULT nextval('public.farm_devices_device_id_seq'::regclass);


--
-- Name: farm_log farm_log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm_log ALTER COLUMN farm_log_id SET DEFAULT nextval('public.farm_log_farm_log_id_seq'::regclass);


--
-- Name: farmer farmer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer ALTER COLUMN farmer_id SET DEFAULT nextval('public.farmer_farmer_id_seq'::regclass);


--
-- Name: field_data field_data_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field_data ALTER COLUMN field_data_id SET DEFAULT nextval('public.field_data_field_data_id_seq'::regclass);


--
-- Name: moisture_data moisture_data_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moisture_data ALTER COLUMN moisture_data_id SET DEFAULT nextval('public.moisture_data_moisture_data_id_seq'::regclass);


--
-- Name: section section_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section ALTER COLUMN section_id SET DEFAULT nextval('public.section_section_id_seq'::regclass);


--
-- Name: section_devices section_device_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section_devices ALTER COLUMN section_device_id SET DEFAULT nextval('public.devices_device_id_seq'::regclass);


--
-- Name: valve_data valve_data_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.valve_data ALTER COLUMN valve_data_id SET DEFAULT nextval('public.valve_data_valve_data_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (admin_id, admin_fname, admin_lname, admin_password, admin_phone, admin_email, join_date, admin_location, admin_session_key) FROM stdin;
101	admin	admin	Admin	9090909090	admin@gmail.com	2024-10-26	Bengaluru	0b4f2017fc318fbe0f3fcf527af3f269
\.


--
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farm (farm_id, farm_name, creation_date, farmer_id, farm_size, farm_location_cordinates, auto_on_threshold, auto_off_threshold, farm_key) FROM stdin;
11	Coconut	2024-11-12	1001	20.5	{"13.024355, 77.444575","13.024135, 77.445396","13.022801, 77.444804","13.022577, 77.444265","13.022756, 77.443837"}	30	70	farm_key
3	mango	2024-11-05	1002	15	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	30	70	farm_key
5	grapes	2024-11-05	1002	20	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	30	70	farm_key
7	pomegranates	2024-11-05	1002	5	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	30	70	farm_key
8	jackfruit	2024-11-05	1002	14	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	30	70	farm_key
9	plum	2024-11-05	1002	7	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	30	70	farm_key
10	pineapples	2024-11-05	1002	5	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	30	70	farm_key
6	apple	2024-11-05	1002	11	{"16.225329,74.841749","16.225228,74.841714","16.225156,74.842699","16.225268,74.842715"}	9	91	farm_key
2	apple	2024-10-31	1002	20.4	{"13.015136, 77.434778","13.014924, 77.435800","13.014661, 77.435746","13.014514, 77.436511","13.013772, 77.436218","13.014289, 77.434572"}	25	30	farm_key
1	Arecanut	2024-10-26	1001	10	{"13.175372, 77.128259","13.175014, 77.130762","13.173209, 77.130025","13.173669, 77.127761"}	50	50	farm_key
4	guava	2024-11-05	1002	9	{"13.175372, 77.128259","13.175014, 77.130762","13.173209, 77.130025","13.173669, 77.127761"}	30	70	farm_key
\.


--
-- Data for Name: farm_devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farm_devices (farm_device_id, farm_id, device_name, device_location, installation_date) FROM stdin;
3	11	npk	13.022804, 77.444095	2024-11-07
4	2	npk	13.014689, 77.435565	2024-11-11
1	1	npk	13.174343, 77.129044	2024-10-27
\.


--
-- Data for Name: farm_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farm_log (farm_log_id, farm_id, description, "timestamp") FROM stdin;
\.


--
-- Data for Name: farmer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farmer (farmer_id, farmer_fname, farmer_lname, farmer_password, farmer_phone, farmer_email, join_date, admin_id, farmer_session_key) FROM stdin;
1002	abhi	abc	Farmer	1234567889	abhi@gmail.com	2024-10-29	101	2567b659ca38da7d34b767f513a540eb
1001	ganishka	zalli	Farmer	8431234579	farmer1@gmail.com	2024-10-26	101	2afd15d068a057345c8a9033ab94d2f8
\.


--
-- Data for Name: field_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.field_data (field_data_id, farm_device_id, nitrogen, phosphorus, potassium, temperature, humidity, "timestamp") FROM stdin;
1	1	50	40	60	30	70	2024-10-27 18:25:48.03144
2	1	91	92	93	30	67	2024-10-30 06:45:35.518359
3	1	70	80	90	29	90	2024-11-05 08:29:58.263511
4	3	90	87	49	33	77	2024-11-05 08:30:28.205521
5	4	55	66	77	33	92	2024-11-05 08:30:54.095769
6	1	11	30	50	32	67	2024-11-12 10:14:34.040702
7	1	21	30	50	32	67	2024-11-12 10:15:20.705851
12	1	21	30	50	32	67	2024-11-13 05:53:20.845302
13	1	21	30	50	32	67	2024-11-12 04:33:33.3333
14	1	21	30	50	32	67	2024-11-13 06:59:17.639872
15	1	21	30	50	32	67	2024-11-13 07:03:48.381562
16	1	21	\N	50	32	67	2024-11-13 07:04:13.007814
18	4	21	30	50	32	67	2024-11-12 04:33:33.3333
19	4	21	30	50	32	67	2024-11-13 07:16:27.259693
20	4	21	30	50	32	67	2024-11-13 07:18:59.349994
21	4	21	30	50	32	67	2024-11-13 10:04:39.884374
17	1	21	30	50	32	67	2024-11-13 07:04:16.148323
\.


--
-- Data for Name: moisture_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moisture_data (moisture_data_id, section_device_id, "timestamp", moisture_value) FROM stdin;
123	1	2024-11-18 12:42:08.507735	0
124	4	2024-11-18 12:42:19.409466	11
1	1	2024-10-25 11:00:48.725088	75
125	5	2024-11-18 12:42:31.418291	0
126	1	2024-11-18 12:42:51.769203	5
127	5	2024-11-18 12:43:01.442246	0
128	4	2024-11-18 12:43:19.426971	0
7	1	2024-11-05 07:33:38.76544	59
8	1	2024-11-05 07:43:38.76544	30
9	1	2024-11-05 08:13:38.76544	20
10	1	2024-11-05 09:13:38.76544	11
129	1	2024-11-18 12:44:21.814251	0
130	4	2024-11-18 12:44:49.465172	0
131	4	2024-11-18 12:45:19.491909	0
2	4	2024-10-25 16:48:29.540639	88
4	4	2024-10-30 05:11:06.306372	60
132	1	2024-11-18 12:45:21.833028	10
133	2	2024-11-18 12:45:24.899621	62
134	4	2024-11-18 12:45:49.542127	0
6	7	2024-11-05 07:13:38.76544	60
12	1	2024-11-05 10:43:38.76544	30
135	1	2024-11-18 12:45:51.840522	11
3	2	2024-10-30 05:11:06.306372	40
11	2	2024-11-05 10:13:38.76544	30
5	5	2024-11-05 07:11:38.76544	70
13	8	2024-11-11 05:51:09.903922	55
14	9	2024-11-11 05:51:09.903922	44
15	10	2024-11-11 05:51:09.903922	33
16	12	2024-11-11 05:52:17.961188	60
17	13	2024-11-11 05:52:17.961188	50
18	14	2024-11-11 05:52:17.961188	40
19	15	2024-11-11 14:42:17.961188	30
20	17	2024-11-12 04:54:29.080818	60
21	18	2024-11-12 04:54:29.080818	80
22	20	2024-11-12 06:19:52.735698	55
23	22	2024-11-12 06:19:52.735698	44
24	24	2024-11-12 06:44:44.835528	99
25	1	2024-11-12 04:02:50.6386	11
26	3	2024-11-12 04:02:50.6386	97
27	2	2024-11-12 04:02:50.6386	55
28	1	2024-11-12 04:04:50.6386	11
29	1	2024-11-12 04:07:50.6386	11
30	1	2024-11-12 04:30:50.6386	39
31	1	2024-11-12 11:19:45.435896	39
136	2	2024-11-18 12:45:54.922545	62
32	1	2024-11-13 05:54:42.02598	39
34	1	2024-11-12 04:33:33.3333	34
35	2	2024-11-12 04:33:33.3333	34
36	1	2024-11-13 06:27:57.783969	36
37	1	2024-11-13 09:28:16.298604	77
38	1	2024-11-13 09:30:32.545526	70
39	1	2024-11-17 05:51:00.221546	70
40	1	2024-11-17 06:02:23.281693	0
41	1	2024-11-17 06:04:19.242164	0
42	1	2024-11-17 06:04:39.98027	0
43	1	2024-11-17 06:04:55.285529	0
44	1	2024-11-17 06:05:13.216799	0
45	1	2024-11-17 06:05:30.73666	0
46	1	2024-11-17 06:05:49.160307	0
47	1	2024-11-17 07:09:43.843052	36
48	1	2024-11-17 07:09:53.015918	37
49	1	2024-11-17 07:10:02.643284	36
50	1	2024-11-17 07:10:12.842307	36
51	1	2024-11-17 07:10:22.802864	36
52	1	2024-11-17 07:10:32.986772	36
53	1	2024-11-17 07:10:43.178709	35
54	1	2024-11-17 07:10:53.160669	58
55	1	2024-11-17 07:11:03.130229	59
56	1	2024-11-17 10:29:19.306281	62
57	1	2024-11-17 15:33:26.361807	99
58	1	2024-11-17 19:08:16.722821	62
59	1	2024-11-17 19:37:23.297072	62
60	1	2024-11-17 19:37:40.79435	62
61	1	2024-11-17 19:37:58.964009	62
62	1	2024-11-17 19:38:16.934584	62
63	1	2024-11-17 19:38:34.672007	62
64	1	2024-11-17 15:56:22.29005	99
65	1	2024-11-17 19:08:16.722821	62
66	1	2024-11-17 21:27:55.274037	62
67	1	2024-11-17 21:28:13.345344	61
68	1	2024-11-17 21:28:31.334628	62
69	1	2024-11-17 21:28:49.452167	61
70	1	2024-11-17 21:29:07.333198	62
71	1	2024-11-17 21:29:25.326303	27
72	1	2024-11-17 21:42:01.410564	62
73	1	2024-11-18 12:37:19.897261	62
74	2	2024-11-18 12:24:32.802843	0
75	2	2024-11-18 12:25:02.80118	0
76	2	2024-11-18 12:25:05.706438	96
77	2	2024-11-18 12:25:35.724706	59
78	2	2024-11-18 12:26:02.801621	0
79	1	2024-11-18 12:26:40.284475	14
80	2	2024-11-18 12:27:33.110142	4
81	1	2024-11-18 12:28:11.827444	0
82	1	2024-11-18 12:28:41.522733	0
83	4	2024-11-18 12:28:46.269775	50
84	1	2024-11-18 12:29:11.628201	0
85	1	2024-11-18 12:29:41.733304	0
86	1	2024-11-18 12:30:11.634027	0
87	1	2024-11-18 12:30:41.542033	0
88	5	2024-11-18 12:30:51.91273	0
89	1	2024-11-18 12:31:11.540904	0
90	5	2024-11-18 12:31:21.921059	0
91	1	2024-11-18 12:31:41.573238	0
92	5	2024-11-18 12:31:51.919648	74
93	4	2024-11-18 12:32:18.893156	3
94	5	2024-11-18 12:32:21.92204	0
95	1	2024-11-18 12:34:04.907199	0
96	4	2024-11-18 12:34:18.978996	4
97	1	2024-11-18 12:34:35.018272	0
98	4	2024-11-18 12:34:48.983982	23
99	5	2024-11-18 12:34:52.064652	1
100	4	2024-11-18 12:35:19.004436	0
101	5	2024-11-18 12:35:23.701113	71
102	1	2024-11-18 12:36:04.362541	61
103	1	2024-11-18 12:36:34.414006	62
104	4	2024-11-18 12:36:49.101093	0
105	5	2024-11-18 12:37:23.734983	0
106	4	2024-11-18 12:37:49.237117	0
107	5	2024-11-18 12:37:53.741126	10
108	1	2024-11-18 12:37:59.169868	62
109	4	2024-11-18 12:38:19.261768	3
110	5	2024-11-18 12:38:23.7513	0
111	4	2024-11-18 12:38:49.274406	6
112	5	2024-11-18 12:38:53.77016	0
113	1	2024-11-18 12:38:59.206169	61
114	4	2024-11-18 12:39:19.285402	0
115	1	2024-11-18 12:39:29.207608	61
116	1	2024-11-18 12:39:59.236724	62
117	4	2024-11-18 12:40:49.335783	0
118	1	2024-11-18 12:41:08.488957	0
119	4	2024-11-18 12:41:19.376056	0
120	5	2024-11-18 12:41:23.944369	0
121	1	2024-11-18 12:41:38.49817	0
122	4	2024-11-18 12:41:49.396805	1
137	4	2024-11-18 12:46:19.536691	4
138	1	2024-11-18 12:46:51.842928	0
139	4	2024-11-18 12:47:19.561571	0
140	1	2024-11-18 12:47:21.855856	16
141	4	2024-11-18 12:47:50.078638	0
142	5	2024-11-18 12:48:02.037014	0
143	4	2024-11-18 12:48:20.182115	0
144	1	2024-11-18 12:48:22.303138	10
145	5	2024-11-18 12:48:32.038729	0
146	5	2024-11-18 12:49:02.095083	0
147	4	2024-11-18 12:49:50.191209	0
148	4	2024-11-18 12:50:20.199535	0
149	5	2024-11-18 12:50:32.133213	0
150	2	2024-11-18 12:50:34.7421	62
151	2	2024-11-18 12:51:04.743312	62
152	2	2024-11-18 12:51:34.862862	62
153	1	2024-11-18 12:51:53.242796	10
154	5	2024-11-18 12:52:02.163744	0
155	4	2024-11-18 12:52:20.508276	0
156	1	2024-11-18 12:52:23.363106	0
157	1	2024-11-18 12:52:53.366976	11
158	4	2024-11-18 12:54:20.586195	25
159	1	2024-11-18 12:54:23.507033	0
160	5	2024-11-18 12:54:33.97509	0
161	2	2024-11-18 12:54:35.417343	63
162	4	2024-11-18 12:54:50.595355	0
163	5	2024-11-18 12:55:03.97618	0
164	2	2024-11-18 12:55:05.431032	62
165	1	2024-11-18 12:55:23.507713	14
166	2	2024-11-18 12:55:35.440292	62
167	1	2024-11-18 12:55:53.526867	0
168	2	2024-11-18 12:56:05.464344	62
169	4	2024-11-18 12:56:20.642823	0
170	1	2024-11-18 12:56:23.537685	0
171	4	2024-11-18 12:56:51.573007	0
172	1	2024-11-18 12:56:53.538762	8
173	2	2024-11-18 12:57:05.455045	62
174	5	2024-11-18 12:58:04.945218	0
175	2	2024-11-18 12:58:05.502314	62
176	4	2024-11-18 12:58:21.613445	0
177	1	2024-11-18 12:58:23.630237	0
178	2	2024-11-18 12:58:35.528973	62
179	5	2024-11-18 12:58:35.64703	0
180	4	2024-11-18 12:58:51.63314	0
181	1	2024-11-18 12:58:53.623136	2
182	5	2024-11-18 12:59:07.217556	0
183	1	2024-11-18 12:59:23.631218	0
184	2	2024-11-18 12:59:35.85831	62
185	4	2024-11-18 12:59:51.699384	0
186	1	2024-11-18 12:59:53.693564	0
187	2	2024-11-18 13:00:05.955933	62
188	4	2024-11-18 13:00:22.145861	0
189	1	2024-11-18 13:00:23.701873	0
190	2	2024-11-18 13:00:36.122475	62
191	4	2024-11-18 13:00:52.227863	0
192	2	2024-11-18 13:01:06.237767	62
193	5	2024-11-18 13:01:07.292849	0
194	4	2024-11-18 13:01:22.235204	0
195	4	2024-11-18 13:01:52.244215	0
196	1	2024-11-18 13:01:53.757705	0
197	5	2024-11-18 13:02:07.410466	0
198	1	2024-11-18 13:02:23.800153	0
199	2	2024-11-18 13:02:37.722509	62
200	4	2024-11-18 13:02:52.246084	3
201	5	2024-11-18 13:03:07.491536	0
202	5	2024-11-18 13:03:37.429708	0
203	2	2024-11-18 13:04:20.244471	62
204	5	2024-11-18 13:04:37.459077	0
205	2	2024-11-18 13:04:48.019881	62
206	1	2024-11-18 13:04:54.04597	0
207	4	2024-11-18 13:05:22.261169	0
208	1	2024-11-18 13:05:24.043064	0
209	4	2024-11-18 13:05:52.879114	0
210	1	2024-11-18 13:05:54.043988	0
211	4	2024-11-18 13:06:22.968035	0
212	1	2024-11-18 13:06:26.612359	0
213	2	2024-11-18 14:34:09.995111	62
214	2	2024-11-18 14:34:41.174302	62
215	2	2024-11-18 14:35:12.328615	62
216	2	2024-11-18 14:35:43.565894	62
217	2	2024-11-18 14:36:46.243463	62
218	2	2024-11-18 14:37:17.774237	64
219	2	2024-11-18 14:37:39.907861	62
220	2	2024-11-18 14:38:11.038935	62
221	2	2024-11-18 14:38:42.570359	62
222	2	2024-11-18 14:39:13.733353	62
223	2	2024-11-18 14:39:44.910291	62
224	2	2024-11-18 14:40:16.163241	62
225	2	2024-11-18 14:40:47.733109	62
226	1	2024-11-18 14:43:24.823039	0
227	1	2024-11-18 14:43:55.927587	0
228	1	2024-11-18 14:44:39.736487	0
229	1	2024-11-18 14:45:11.097759	0
230	1	2024-11-18 14:45:20.716654	0
231	1	2024-11-18 14:45:52.250852	0
232	2	2024-11-18 14:45:54.091594	62
233	1	2024-11-18 14:46:23.788275	0
234	2	2024-11-18 14:46:27.271121	62
235	5	2024-11-18 14:46:51.263844	0
236	1	2024-11-18 14:46:54.968796	0
237	2	2024-11-18 14:46:58.517487	62
238	5	2024-11-18 14:47:23.02639	0
239	1	2024-11-18 14:47:26.126819	0
240	2	2024-11-18 14:47:29.71041	62
241	5	2024-11-18 14:47:54.233003	0
242	1	2024-11-18 14:47:57.317016	0
243	2	2024-11-18 14:48:01.669268	62
244	1	2024-11-18 14:48:28.926395	41
245	2	2024-11-18 14:48:33.214349	62
246	1	2024-11-18 14:49:00.456953	17
247	2	2024-11-18 14:49:04.969238	61
248	1	2024-11-18 14:49:31.993322	11
249	2	2024-11-18 14:49:36.161026	62
250	4	2024-11-18 14:49:49.399523	16
251	1	2024-11-18 14:50:03.529777	0
252	2	2024-11-18 14:50:07.623212	62
253	4	2024-11-18 14:50:20.492674	77
254	1	2024-11-18 14:50:35.075597	0
255	2	2024-11-18 14:50:39.163908	62
256	1	2024-11-18 14:51:06.420875	48
257	2	2024-11-18 14:51:10.732834	61
258	4	2024-11-18 14:51:23.603052	0
259	1	2024-11-18 14:51:37.939596	28
260	2	2024-11-18 14:51:42.236681	62
261	4	2024-11-18 14:51:55.149643	61
262	1	2024-11-18 14:52:09.482701	0
263	2	2024-11-18 14:52:13.821088	62
264	4	2024-11-18 14:52:26.724759	43
265	1	2024-11-18 14:52:41.034046	2
266	2	2024-11-18 14:52:45.318354	62
267	4	2024-11-18 14:52:58.220965	24
268	1	2024-11-18 14:53:12.241038	10
269	2	2024-11-18 14:53:18.902041	62
270	4	2024-11-18 14:53:29.759169	8
271	1	2024-11-18 14:53:43.484944	8
272	2	2024-11-18 14:53:50.445892	62
273	4	2024-11-18 14:54:01.297698	0
274	1	2024-11-18 14:54:15.021136	7
275	2	2024-11-18 14:54:22.032075	62
276	4	2024-11-18 14:54:34.476673	38
277	1	2024-11-18 14:54:46.573761	0
278	2	2024-11-18 14:54:53.520247	62
279	4	2024-11-18 14:55:07.037308	54
280	1	2024-11-18 14:55:18.094968	0
281	2	2024-11-18 14:55:25.060762	62
282	4	2024-11-18 14:55:38.577245	0
283	1	2024-11-18 14:55:49.330292	0
284	2	2024-11-18 14:55:56.60538	61
285	4	2024-11-18 14:56:10.115499	2
286	1	2024-11-18 14:56:20.512608	0
287	2	2024-11-18 14:56:28.139645	62
288	4	2024-11-18 14:56:41.660173	0
289	1	2024-11-18 14:56:52.363052	0
290	2	2024-11-18 14:56:59.678884	62
291	4	2024-11-18 14:57:13.196155	47
292	5	2024-11-18 14:57:21.021479	0
293	1	2024-11-18 14:57:23.846208	0
294	2	2024-11-18 14:57:31.01491	62
295	4	2024-11-18 14:57:44.737156	0
296	5	2024-11-18 14:57:52.18337	0
297	1	2024-11-18 14:57:55.402249	0
298	2	2024-11-18 14:58:02.55544	62
299	4	2024-11-18 14:58:16.276154	5
300	5	2024-11-18 14:58:23.645653	2
301	1	2024-11-18 14:58:26.930955	12
302	2	2024-11-18 14:58:34.108584	62
303	4	2024-11-18 14:58:47.496893	0
304	5	2024-11-18 14:58:54.917112	0
305	1	2024-11-18 14:58:58.129286	16
306	2	2024-11-18 14:59:05.633755	62
307	4	2024-11-18 14:59:18.697969	19
308	5	2024-11-18 14:59:26.164528	0
309	1	2024-11-18 14:59:29.318357	29
310	2	2024-11-18 14:59:36.857644	62
311	4	2024-11-18 14:59:50.281502	0
312	5	2024-11-18 14:59:57.451084	2
313	1	2024-11-18 15:00:00.975809	0
314	2	2024-11-18 15:00:09.328829	62
315	4	2024-11-18 15:00:21.81982	0
316	5	2024-11-18 15:00:28.686882	0
317	1	2024-11-18 15:00:32.471893	27
318	2	2024-11-18 15:00:40.586021	62
319	4	2024-11-18 15:00:54.385197	3
320	5	2024-11-18 15:01:00.117821	0
321	1	2024-11-18 15:01:04.012696	59
322	2	2024-11-18 15:01:11.775759	62
323	4	2024-11-18 15:01:25.924649	32
324	5	2024-11-18 15:01:31.660904	1
325	1	2024-11-18 15:01:35.339695	19
326	2	2024-11-18 15:01:43.34032	61
327	4	2024-11-18 15:01:57.469882	0
328	5	2024-11-18 15:02:03.199335	0
329	1	2024-11-18 15:02:06.882925	0
330	2	2024-11-18 15:02:14.874903	62
331	4	2024-11-18 15:02:29.002589	0
332	5	2024-11-18 15:02:34.743139	11
333	1	2024-11-18 15:02:38.424497	19
334	2	2024-11-18 15:02:46.085032	62
335	4	2024-11-18 15:03:00.250158	14
336	5	2024-11-18 15:03:06.077632	8
337	1	2024-11-18 15:03:09.615881	43
338	2	2024-11-18 15:03:17.278318	62
339	4	2024-11-18 15:03:31.436582	56
340	5	2024-11-18 15:03:37.636503	0
341	1	2024-11-18 15:03:40.79693	5
342	2	2024-11-18 15:03:48.460785	62
343	4	2024-11-18 15:04:03.016043	13
344	5	2024-11-18 15:04:08.886184	0
345	1	2024-11-18 15:04:12.019842	24
346	2	2024-11-18 15:04:19.67819	62
347	4	2024-11-18 15:04:34.266347	60
348	5	2024-11-18 15:04:40.221558	0
349	1	2024-11-18 15:04:43.219252	0
350	2	2024-11-18 15:04:50.839294	62
351	4	2024-11-18 15:05:05.471654	58
352	5	2024-11-18 15:05:11.399581	0
353	1	2024-11-18 15:05:14.697468	0
354	2	2024-11-18 15:05:22.038013	62
355	4	2024-11-18 15:05:36.67382	4
356	5	2024-11-18 15:05:42.96566	0
357	1	2024-11-18 15:05:45.920153	0
358	2	2024-11-18 15:05:53.240829	62
359	4	2024-11-18 15:06:07.914007	0
360	5	2024-11-18 15:06:14.21673	0
361	1	2024-11-18 15:06:17.174715	0
362	2	2024-11-18 15:06:24.410125	62
363	4	2024-11-18 15:06:39.131098	0
364	5	2024-11-18 15:06:45.456158	0
365	1	2024-11-18 15:06:50.36274	0
366	2	2024-11-18 15:06:55.631449	61
367	4	2024-11-18 15:07:10.807958	0
368	5	2024-11-18 15:07:16.958005	0
369	1	2024-11-18 15:07:21.697872	0
370	2	2024-11-18 15:07:29.24413	62
371	4	2024-11-18 15:07:42.046908	0
372	5	2024-11-18 15:07:48.199117	0
373	1	2024-11-18 15:07:52.874976	0
374	2	2024-11-18 15:08:00.465179	62
375	4	2024-11-18 15:08:13.336353	60
376	5	2024-11-18 15:08:19.848369	1
377	1	2024-11-18 15:08:24.328908	28
378	2	2024-11-18 15:08:31.70813	61
379	4	2024-11-18 15:08:44.613919	0
380	5	2024-11-18 15:08:51.367605	11
381	1	2024-11-18 15:08:55.667474	4
382	2	2024-11-18 15:09:03.298559	62
383	4	2024-11-18 15:09:16.151694	56
384	5	2024-11-18 15:09:22.908619	2
385	1	2024-11-18 15:09:26.854308	44
386	2	2024-11-18 15:09:34.786963	61
387	4	2024-11-18 15:09:47.34516	0
388	5	2024-11-18 15:09:54.447251	12
389	1	2024-11-18 15:09:58.334168	56
390	2	2024-11-18 15:10:06.327567	62
391	4	2024-11-18 15:10:18.616969	90
392	5	2024-11-18 15:10:25.983554	0
393	1	2024-11-18 15:10:29.878288	0
394	2	2024-11-18 15:10:37.542959	62
395	4	2024-11-18 15:10:50.155305	0
396	1	2024-11-19 15:37:47.262235	0
397	5	2024-11-19 12:41:11.370164	0
398	5	2024-11-19 12:41:42.57727	6
399	5	2024-11-19 12:42:14.040731	8
400	5	2024-11-19 12:42:46.599392	0
401	5	2024-11-19 12:43:17.92909	0
402	5	2024-11-19 12:43:49.192636	0
403	5	2024-11-19 12:44:20.563209	8
404	5	2024-11-19 12:44:52.019006	0
405	5	2024-11-19 12:45:23.502103	0
406	5	2024-11-19 12:45:55.154058	5
407	5	2024-11-19 12:46:26.586561	0
408	5	2024-11-19 12:46:58.240719	3
409	5	2024-11-19 12:47:29.584713	5
410	5	2024-11-19 12:48:00.902734	6
411	5	2024-11-19 12:48:32.325038	0
412	5	2024-11-19 12:49:03.558253	0
413	5	2024-11-19 12:49:34.947275	0
414	5	2024-11-19 12:50:06.261614	6
415	5	2024-11-19 12:50:37.905553	0
416	5	2024-11-19 12:51:09.757481	4
417	5	2024-11-19 12:51:41.52104	0
418	5	2024-11-19 12:52:12.798453	0
419	5	2024-11-19 13:09:06.092468	6
420	5	2024-11-19 13:09:37.377436	4
421	5	2024-11-19 13:10:09.245433	0
422	5	2024-11-19 13:10:40.813188	0
423	5	2024-11-19 13:11:44.889496	9
424	5	2024-11-19 13:12:16.451368	0
425	5	2024-11-19 13:12:47.955657	0
426	5	2024-11-19 13:13:19.329136	3
427	5	2024-11-19 13:13:50.660156	10
428	5	2024-11-19 13:14:10.915492	0
429	5	2024-11-19 13:14:42.131887	6
430	5	2024-11-19 13:15:13.377148	2
431	5	2024-11-19 13:15:45.02275	0
432	5	2024-11-19 13:17:19.57318	0
433	5	2024-11-19 13:18:23.000907	3
434	5	2024-11-19 13:19:57.614296	0
435	5	2024-11-19 13:21:31.813343	0
436	5	2024-11-19 13:22:03.362633	5
437	5	2024-11-19 13:23:39.215592	0
438	5	2024-11-19 13:24:41.867035	0
439	5	2024-11-19 13:25:44.748634	0
440	5	2024-11-19 13:26:47.658137	0
441	5	2024-11-19 13:27:50.27782	10
442	5	2024-11-19 13:28:22.856948	0
443	5	2024-11-19 13:28:35.96681	0
444	5	2024-11-19 15:20:46.883294	8
445	5	2024-11-19 15:21:18.13891	37
446	5	2024-11-19 15:21:49.325446	0
447	5	2024-11-19 15:22:20.565726	41
448	5	2024-11-19 15:22:52.170549	0
449	5	2024-11-19 15:23:23.398353	2
450	5	2024-11-19 15:23:54.688134	1
451	5	2024-11-19 15:24:25.895153	0
452	5	2024-11-19 15:24:57.905762	35
453	5	2024-11-19 15:25:29.151426	0
454	5	2024-11-19 15:26:00.376918	0
455	5	2024-11-19 15:26:31.58561	0
456	5	2024-11-19 15:27:02.853089	4
457	5	2024-11-19 15:27:34.386423	17
458	5	2024-11-19 16:05:34.817757	14
459	5	2024-11-19 16:06:06.362532	1
460	5	2024-11-19 16:06:37.899817	18
461	5	2024-11-19 16:07:09.439747	0
462	5	2024-11-19 16:07:40.977262	0
463	5	2024-11-19 16:08:12.511039	1
464	5	2024-11-19 16:08:44.098689	10
465	5	2024-11-19 16:09:15.389207	12
466	4	2024-11-19 16:09:45.291379	13
467	4	2024-11-19 16:10:16.831962	21
468	4	2024-11-19 16:10:48.375172	0
469	4	2024-11-19 16:11:19.911174	20
470	4	2024-11-19 16:11:51.448964	0
471	4	2024-11-19 16:12:22.991846	10
472	4	2024-11-19 16:12:55.567944	13
473	4	2024-11-19 16:13:27.087088	0
474	4	2024-11-19 16:13:58.634936	0
475	4	2024-11-19 16:14:30.228281	15
476	7	2024-11-19 16:14:53.311218	8
477	7	2024-11-19 16:15:04.98681	11
478	7	2024-11-19 16:15:16.710719	0
479	7	2024-11-19 16:15:28.357997	0
480	7	2024-11-19 16:15:40.02271	0
481	7	2024-11-19 16:15:51.689003	0
482	7	2024-11-19 16:16:03.757948	0
483	7	2024-11-19 16:16:15.441186	18
484	7	2024-11-19 16:16:27.114783	0
485	7	2024-11-19 16:16:38.791406	0
486	20	2024-11-19 16:17:03.768856	26
487	20	2024-11-19 16:17:10.528867	1
488	20	2024-11-19 16:17:16.885331	26
489	20	2024-11-19 16:17:23.683312	0
490	20	2024-11-19 16:17:30.393202	0
491	20	2024-11-19 16:17:37.154885	0
492	20	2024-11-19 16:17:43.910776	22
493	20	2024-11-19 16:17:50.259343	0
494	20	2024-11-19 16:17:57.01771	0
495	20	2024-11-19 16:18:03.784786	0
497	22	2024-11-19 16:18:27.326752	34
498	22	2024-11-19 16:18:33.65897	0
499	22	2024-11-19 16:18:40.025365	18
500	22	2024-11-19 16:18:46.785493	25
501	22	2024-11-19 16:18:53.556277	0
502	22	2024-11-19 16:19:00.301425	0
503	22	2024-11-19 16:19:07.060047	0
504	22	2024-11-19 16:19:13.817263	10
505	22	2024-11-19 16:19:20.168351	12
506	22	2024-11-19 16:19:26.924953	0
507	22	2024-11-19 16:19:40.031769	10
508	22	2024-11-19 16:19:46.382642	0
509	22	2024-11-19 16:19:53.143387	0
510	22	2024-11-19 16:19:59.899118	22
511	22	2024-11-19 16:20:06.656307	24
512	22	2024-11-19 16:20:13.413839	1
513	22	2024-11-19 16:20:19.765052	0
514	22	2024-11-19 16:20:26.109522	0
515	22	2024-11-19 16:20:32.8693	0
516	22	2024-11-19 16:20:39.220879	20
517	22	2024-11-19 16:20:45.977105	21
518	24	2024-11-19 16:21:03.785475	40
519	24	2024-11-19 16:21:10.159382	25
520	24	2024-11-19 16:21:16.902425	22
521	24	2024-11-19 16:21:23.659247	1
522	24	2024-11-19 16:21:30.412307	0
523	24	2024-11-19 16:21:37.187142	26
524	24	2024-11-19 16:21:43.933958	16
525	24	2024-11-19 16:21:50.28977	19
526	24	2024-11-19 16:21:57.059483	0
527	24	2024-11-19 16:22:03.80333	0
528	24	2024-11-19 16:22:10.157134	10
529	24	2024-11-19 16:22:16.908548	0
531	2	2024-11-19 16:22:44.553882	42
532	2	2024-11-19 16:23:15.664907	25
533	2	2024-11-19 16:23:47.242856	0
534	2	2024-11-19 16:24:18.763668	1
535	2	2024-11-19 16:24:50.300975	24
536	2	2024-11-19 16:25:21.521019	24
537	2	2024-11-19 16:25:52.765348	0
538	2	2024-11-19 16:26:24.304076	24
539	2	2024-11-19 16:26:55.843561	0
540	2	2024-11-19 16:27:27.379979	9
541	2	2024-11-19 16:27:58.921361	0
542	2	2024-11-19 16:28:30.46464	20
543	2	2024-11-19 16:29:01.998187	10
544	2	2024-11-19 16:29:33.230105	0
545	2	2024-11-19 16:30:04.464334	0
546	2	2024-11-19 16:30:36.003917	0
547	2	2024-11-19 16:31:07.541312	19
548	2	2024-11-19 16:31:39.085371	0
549	2	2024-11-19 16:32:10.635236	0
550	2	2024-11-19 16:32:41.958543	0
551	2	2024-11-19 16:33:13.185521	0
552	2	2024-11-19 16:33:44.42881	23
553	2	2024-11-19 16:34:15.659351	7
554	2	2024-11-19 16:34:46.902934	13
555	2	2024-11-19 16:35:18.435436	4
556	2	2024-11-19 16:35:49.973384	0
557	2	2024-11-19 16:36:21.70546	3
558	2	2024-11-19 16:36:53.292652	0
559	2	2024-11-19 16:37:24.804117	0
560	2	2024-11-19 16:37:56.377103	10
561	2	2024-11-19 16:38:27.880732	23
562	2	2024-11-19 16:38:59.417643	0
563	2	2024-11-19 16:39:30.622337	5
564	2	2024-11-19 16:40:01.89013	18
565	2	2024-11-19 16:40:33.43243	0
566	2	2024-11-19 16:41:04.798476	26
567	2	2024-11-19 16:41:36.307287	3
568	2	2024-11-19 16:42:07.517027	0
569	2	2024-11-19 16:42:38.763411	5
570	2	2024-11-19 16:43:10.493458	0
571	2	2024-11-19 16:43:42.045762	0
572	2	2024-11-19 16:44:13.256437	4
573	2	2024-11-19 16:44:44.511387	16
574	2	2024-11-19 16:45:15.749348	0
575	2	2024-11-19 16:45:47.001907	5
576	2	2024-11-19 16:46:18.518417	25
577	2	2024-11-19 16:46:50.066086	0
578	2	2024-11-19 16:47:21.333903	18
579	2	2024-11-19 16:47:52.937753	0
580	2	2024-11-19 16:48:24.473383	13
581	2	2024-11-19 16:48:56.028833	0
582	2	2024-11-19 16:49:27.246183	5
583	2	2024-11-19 16:49:58.473263	28
584	2	2024-11-19 16:50:30.012418	1
585	2	2024-11-19 16:51:01.223107	0
586	2	2024-11-19 16:51:32.480801	0
587	2	2024-11-19 16:52:03.690613	0
588	2	2024-11-19 16:52:34.944356	0
589	2	2024-11-19 16:53:06.493479	16
590	2	2024-11-19 16:53:38.023901	16
591	2	2024-11-19 16:54:09.236363	0
592	2	2024-11-19 16:54:40.699146	11
593	2	2024-11-19 16:55:12.267898	0
594	2	2024-11-19 16:57:14.972148	0
607	2	2024-11-20 09:45:44.110195	61
608	1	2024-11-20 09:45:53.336782	62
609	2	2024-11-20 09:46:15.449365	62
610	1	2024-11-20 09:46:24.599104	62
611	2	2024-11-20 09:46:46.654986	62
530	24	2024-11-19 16:22:23.666482	30
595	1	2024-11-20 09:38:09.747891	19
596	1	2024-11-20 09:38:20.587054	10
597	2	2024-11-20 09:40:09.32004	12
598	2	2024-11-20 09:40:22.632424	2
599	1	2024-11-20 09:41:15.523794	62
600	1	2024-11-20 09:42:53.861951	62
601	4	2024-11-20 09:43:04.579353	19
602	1	2024-11-20 09:43:48.198486	63
603	5	2024-11-20 09:44:14.620929	5
604	1	2024-11-20 09:44:19.340493	33
605	1	2024-11-20 09:44:50.861131	63
606	1	2024-11-20 09:45:22.04435	62
612	1	2024-11-20 09:46:56.233854	62
613	2	2024-11-20 09:47:18.127875	62
614	1	2024-11-20 09:47:27.738209	61
615	2	2024-11-20 09:47:49.444288	62
616	1	2024-11-20 09:47:58.969129	63
617	2	2024-11-20 09:48:20.975272	61
618	1	2024-11-20 09:48:30.210995	63
619	2	2024-11-20 09:48:52.160343	62
620	1	2024-11-20 09:49:01.463512	64
621	5	2024-11-20 09:49:04.629019	64
622	1	2024-11-20 09:49:33.073059	63
623	5	2024-11-20 09:49:37.911262	64
624	7	2024-11-20 09:50:03.465266	0
625	1	2024-11-20 09:50:07.420803	64
626	5	2024-11-20 09:50:18.294701	64
627	7	2024-11-20 09:50:35.137862	0
628	1	2024-11-20 09:50:39.070419	62
629	5	2024-11-20 09:50:49.973307	63
630	7	2024-11-20 09:51:06.369425	0
631	1	2024-11-20 09:51:10.295915	63
632	5	2024-11-20 09:51:21.63539	63
633	1	2024-11-20 09:51:41.98854	63
634	5	2024-11-20 09:51:53.155639	64
635	1	2024-11-20 09:52:13.172081	63
636	5	2024-11-20 09:52:24.704948	64
637	1	2024-11-20 09:52:44.776723	60
638	5	2024-11-20 09:52:56.238945	65
639	2	2024-11-20 09:53:04.429458	62
640	1	2024-11-20 09:53:15.981441	63
641	5	2024-11-20 09:53:27.57387	64
642	2	2024-11-20 09:53:36.178077	62
643	1	2024-11-20 09:53:47.25732	62
644	5	2024-11-20 09:53:58.844926	65
645	2	2024-11-20 09:54:07.708232	62
646	1	2024-11-20 09:54:18.649604	63
647	5	2024-11-20 09:54:30.653079	63
648	2	2024-11-20 09:54:38.898076	62
649	1	2024-11-20 09:54:52.171071	63
650	5	2024-11-20 09:55:01.884959	64
651	2	2024-11-20 09:55:10.084037	62
652	1	2024-11-20 09:55:24.917594	62
653	5	2024-11-20 09:55:33.170725	64
654	2	2024-11-20 09:55:41.505946	63
655	1	2024-11-20 09:55:56.118048	63
656	5	2024-11-20 09:56:04.85706	63
657	2	2024-11-20 09:56:13.066271	62
658	1	2024-11-20 09:56:27.463192	63
659	5	2024-11-20 09:56:38.462382	64
660	2	2024-11-20 09:56:44.317231	62
661	1	2024-11-20 09:56:58.66314	63
662	5	2024-11-20 09:57:09.768994	64
663	2	2024-11-20 09:57:15.917004	62
664	1	2024-11-20 09:57:29.856879	63
665	5	2024-11-20 09:57:41.31646	65
666	2	2024-11-20 09:57:48.485267	62
667	1	2024-11-20 09:58:01.095279	63
668	5	2024-11-20 09:58:12.885064	63
669	2	2024-11-20 09:58:19.686857	62
670	1	2024-11-20 09:58:32.313021	63
671	5	2024-11-20 09:58:46.207379	64
672	2	2024-11-20 09:58:50.881012	62
673	1	2024-11-20 09:59:03.52281	63
674	5	2024-11-20 09:59:17.990886	65
675	2	2024-11-20 09:59:22.279263	63
676	1	2024-11-20 09:59:37.053638	62
677	5	2024-11-20 09:59:49.574759	64
678	2	2024-11-20 09:59:53.544198	62
679	1	2024-11-20 10:00:08.286531	63
680	5	2024-11-20 10:00:20.731034	64
681	2	2024-11-20 10:00:24.943677	62
682	1	2024-11-20 10:00:39.483536	62
683	5	2024-11-20 10:00:52.058406	64
684	2	2024-11-20 10:00:56.177061	62
685	1	2024-11-20 10:01:11.256312	65
686	5	2024-11-20 10:01:23.521746	65
687	2	2024-11-20 10:01:27.420691	62
688	1	2024-11-20 10:01:42.966391	62
689	5	2024-11-20 10:01:54.76868	63
690	2	2024-11-20 10:01:58.609197	62
691	1	2024-11-20 10:02:14.142804	63
692	5	2024-11-20 10:02:28.500715	64
693	2	2024-11-20 10:02:29.884937	62
694	7	2024-11-20 10:02:35.805689	24
695	1	2024-11-20 10:02:45.359578	63
696	5	2024-11-20 10:02:59.795265	64
697	2	2024-11-20 10:03:01.416949	62
698	7	2024-11-20 10:03:05.096124	100
699	1	2024-11-20 10:03:16.772128	62
700	5	2024-11-20 10:03:31.040635	65
701	2	2024-11-20 10:03:32.943857	0
702	7	2024-11-20 10:03:36.219669	37
703	1	2024-11-20 10:03:48.344408	62
704	5	2024-11-20 10:04:02.666416	63
705	2	2024-11-20 10:04:04.125719	18
706	7	2024-11-20 10:04:13.707278	52
707	2	2024-11-20 10:04:16.575638	7
708	1	2024-11-20 10:04:19.882798	63
709	5	2024-11-20 10:04:34.188517	65
710	2	2024-11-20 10:04:43.11172	92
711	7	2024-11-20 10:04:44.87575	47
712	1	2024-11-20 10:04:51.433599	62
713	5	2024-11-20 10:05:05.734252	65
714	7	2024-11-20 10:05:16.36594	53
715	1	2024-11-20 10:05:22.963661	63
716	1	2024-11-20 10:05:34.188744	63
717	5	2024-11-20 10:05:36.943539	64
718	7	2024-11-20 10:05:47.906368	84
719	5	2024-11-20 10:06:08.598195	63
720	1	2024-11-20 10:06:09.42689	37
721	1	2024-11-20 10:06:15.986439	36
722	7	2024-11-20 10:06:19.121139	90
723	5	2024-11-20 10:06:44.46044	64
724	7	2024-11-20 10:06:50.60128	0
725	7	2024-11-20 10:07:22.121094	42
726	2	2024-11-20 10:07:39.734685	37
727	7	2024-11-20 10:07:53.659313	38
728	5	2024-11-20 10:08:00.089959	35
729	2	2024-11-20 10:08:10.865401	36
730	4	2024-11-20 10:08:21.310627	61
731	7	2024-11-20 10:08:24.850537	38
732	5	2024-11-20 10:08:27.91589	35
733	2	2024-11-20 10:08:42.604769	37
734	7	2024-11-20 10:08:56.327385	37
735	5	2024-11-20 10:08:59.148398	34
736	2	2024-11-20 10:09:14.148946	36
737	7	2024-11-20 10:09:28.082343	38
738	4	2024-11-20 10:09:29.001058	38
739	5	2024-11-20 10:09:30.742686	35
740	2	2024-11-20 10:09:45.327938	36
741	7	2024-11-20 10:09:59.299637	38
742	5	2024-11-20 10:10:02.28225	35
743	4	2024-11-20 10:10:12.119008	38
744	2	2024-11-20 10:10:16.491689	37
745	7	2024-11-20 10:10:30.742418	38
746	5	2024-11-20 10:10:33.845399	34
747	4	2024-11-20 10:10:43.652061	38
748	2	2024-11-20 10:10:48.152562	37
749	7	2024-11-20 10:11:02.281282	38
750	5	2024-11-20 10:11:05.082276	35
751	4	2024-11-20 10:11:14.876507	38
752	2	2024-11-20 10:11:19.341731	37
753	7	2024-11-20 10:11:34.032871	37
754	5	2024-11-20 10:11:36.879861	35
755	4	2024-11-20 10:11:46.412102	38
756	2	2024-11-20 10:11:52.528595	37
757	7	2024-11-20 10:12:05.295649	38
758	5	2024-11-20 10:12:08.231817	35
759	4	2024-11-20 10:12:18.168685	38
760	2	2024-11-20 10:12:23.804991	37
761	7	2024-11-20 10:12:36.493316	38
762	5	2024-11-20 10:12:39.50049	35
763	4	2024-11-20 10:12:49.704972	38
764	2	2024-11-20 10:12:55.061057	37
765	7	2024-11-20 10:13:08.026117	38
766	5	2024-11-20 10:13:10.745004	35
767	4	2024-11-20 10:13:21.356956	38
768	2	2024-11-20 10:13:26.245821	36
769	7	2024-11-20 10:13:39.569396	37
770	5	2024-11-20 10:13:44.324211	35
771	4	2024-11-20 10:13:52.98636	38
772	2	2024-11-20 10:13:57.811708	37
773	7	2024-11-20 10:14:10.772296	37
774	5	2024-11-20 10:14:15.60867	34
775	4	2024-11-20 10:14:24.255891	38
776	2	2024-11-20 10:14:28.994028	36
777	7	2024-11-20 10:14:42.237789	38
778	5	2024-11-20 10:14:48.229641	35
779	4	2024-11-20 10:14:55.485055	38
780	2	2024-11-20 10:15:00.262503	37
781	7	2024-11-20 10:15:13.431792	37
782	5	2024-11-20 10:15:19.540974	35
783	4	2024-11-20 10:15:26.702764	38
784	2	2024-11-20 10:15:31.803046	37
785	7	2024-11-20 10:15:44.632746	37
786	5	2024-11-20 10:15:50.789238	35
787	4	2024-11-20 10:15:58.22149	38
788	2	2024-11-20 10:16:03.550858	36
789	7	2024-11-20 10:16:16.248826	38
790	5	2024-11-20 10:16:23.025209	34
791	4	2024-11-20 10:16:29.448727	38
792	2	2024-11-20 10:16:34.784957	37
793	7	2024-11-20 10:16:47.49333	38
794	5	2024-11-20 10:16:55.323674	35
795	4	2024-11-20 10:17:00.641524	38
796	2	2024-11-20 10:17:05.970154	37
797	7	2024-11-20 10:17:18.909892	38
798	5	2024-11-20 10:17:26.579799	35
799	4	2024-11-20 10:17:32.225619	38
800	2	2024-11-20 10:17:37.151631	38
801	7	2024-11-20 10:17:50.248565	38
802	5	2024-11-20 10:17:58.048171	35
803	4	2024-11-20 10:18:03.767293	38
804	2	2024-11-20 10:18:08.330326	37
805	7	2024-11-20 10:18:21.79264	37
806	5	2024-11-20 10:18:29.610342	35
807	4	2024-11-20 10:18:35.377159	38
808	2	2024-11-20 10:18:39.807892	37
809	7	2024-11-20 10:18:53.337754	38
810	5	2024-11-20 10:19:00.803261	35
811	4	2024-11-20 10:19:06.838773	38
812	2	2024-11-20 10:19:11.486277	37
813	7	2024-11-20 10:19:24.572436	35
814	5	2024-11-20 10:19:32.033426	35
815	4	2024-11-20 10:19:38.721175	38
816	2	2024-11-20 10:19:43.122591	37
817	7	2024-11-20 10:19:56.194856	34
818	5	2024-11-20 10:20:05.644349	34
819	4	2024-11-20 10:20:10.332622	38
820	2	2024-11-20 10:20:14.644046	37
821	7	2024-11-20 10:20:27.737709	35
822	5	2024-11-20 10:20:36.93471	34
823	4	2024-11-20 10:20:41.866043	38
824	2	2024-11-20 10:20:46.166576	37
825	7	2024-11-20 10:20:59.274223	36
826	5	2024-11-20 10:21:08.515066	35
827	4	2024-11-20 10:21:13.098034	38
828	2	2024-11-20 10:21:17.706723	37
829	7	2024-11-20 10:21:30.819243	35
830	5	2024-11-20 10:21:39.848207	34
831	4	2024-11-20 10:21:44.332682	38
832	2	2024-11-20 10:21:48.927166	37
833	7	2024-11-20 10:22:02.352715	35
834	5	2024-11-20 10:22:11.184796	51
835	4	2024-11-20 10:22:15.668886	38
836	2	2024-11-20 10:22:20.375449	39
837	7	2024-11-20 10:22:33.896268	35
838	5	2024-11-20 10:22:42.699667	51
839	4	2024-11-20 10:22:47.233309	38
840	2	2024-11-20 10:22:51.926951	37
841	7	2024-11-20 10:23:05.435441	35
842	5	2024-11-20 10:23:14.238432	49
843	4	2024-11-20 10:23:18.75484	38
844	2	2024-11-20 10:23:23.496622	37
845	1	2024-11-20 10:23:35.985632	37
846	7	2024-11-20 10:23:36.685165	35
847	5	2024-11-20 10:23:46.262923	49
848	4	2024-11-20 10:23:49.969091	38
849	2	2024-11-20 10:23:54.741749	37
850	7	2024-11-20 10:24:08.207073	36
851	1	2024-11-20 10:24:14.077534	37
852	5	2024-11-20 10:24:17.467775	43
853	4	2024-11-20 10:24:21.214045	38
854	2	2024-11-20 10:24:25.914739	36
855	7	2024-11-20 10:24:39.380256	36
856	1	2024-11-20 10:24:45.217878	37
857	5	2024-11-20 10:24:48.743952	45
858	4	2024-11-20 10:24:52.752597	38
859	2	2024-11-20 10:24:57.258951	36
860	7	2024-11-20 10:25:10.600498	35
861	1	2024-11-20 10:25:16.709562	37
862	5	2024-11-20 10:25:20.065515	45
863	2	2024-11-20 10:25:28.469188	37
864	7	2024-11-20 10:25:41.809386	35
865	5	2024-11-20 10:25:51.276875	45
866	1	2024-11-20 10:25:58.366898	37
867	2	2024-11-20 10:25:59.701678	37
868	4	2024-11-20 10:26:00.643198	38
869	7	2024-11-20 10:26:13.008036	35
870	5	2024-11-20 10:26:22.556422	45
871	2	2024-11-20 10:26:31.255309	37
872	4	2024-11-20 10:26:31.871221	38
873	1	2024-11-20 10:26:37.491212	37
874	7	2024-11-20 10:26:44.268942	35
875	5	2024-11-20 10:26:53.995407	45
876	2	2024-11-20 10:27:02.455792	37
877	4	2024-11-20 10:27:03.298997	38
878	1	2024-11-20 10:27:08.666539	38
879	7	2024-11-20 10:27:15.898594	35
880	5	2024-11-20 10:27:25.524696	45
881	2	2024-11-20 10:27:33.924193	37
882	4	2024-11-20 10:27:34.464227	38
883	1	2024-11-20 10:27:39.870688	38
884	7	2024-11-20 10:27:47.099448	35
885	5	2024-11-20 10:27:56.768039	35
886	2	2024-11-20 10:28:05.137229	37
887	4	2024-11-20 10:28:06.071311	38
888	1	2024-11-20 10:28:11.038642	38
889	7	2024-11-20 10:28:18.36404	36
890	5	2024-11-20 10:28:28.651064	35
891	2	2024-11-20 10:28:36.396993	37
892	4	2024-11-20 10:28:38.243789	38
893	1	2024-11-20 10:28:42.350771	37
894	7	2024-11-20 10:28:49.8037	33
895	5	2024-11-20 10:28:59.879756	35
896	2	2024-11-20 10:29:07.92334	37
897	4	2024-11-20 10:29:09.435658	38
898	1	2024-11-20 10:29:14.579805	37
899	7	2024-11-20 10:29:21.111358	35
900	5	2024-11-20 10:29:31.121128	35
901	2	2024-11-20 10:29:39.462046	37
902	4	2024-11-20 10:29:40.649395	39
903	1	2024-11-20 10:29:45.8055	37
904	7	2024-11-20 10:29:52.340036	36
905	5	2024-11-20 10:30:02.358006	35
906	2	2024-11-20 10:30:10.640763	37
907	4	2024-11-20 10:30:11.87901	38
908	1	2024-11-20 10:30:17.041797	37
909	7	2024-11-20 10:30:23.604765	35
910	5	2024-11-20 10:30:33.951481	35
911	2	2024-11-20 10:30:41.840835	37
912	4	2024-11-20 10:30:43.096721	38
913	1	2024-11-20 10:30:48.273184	38
914	7	2024-11-20 10:30:54.817432	37
915	5	2024-11-20 10:31:05.181791	35
916	2	2024-11-20 10:31:13.026707	37
917	4	2024-11-20 10:31:14.324949	38
918	1	2024-11-20 10:31:19.473254	37
919	7	2024-11-20 10:31:26.367928	35
920	5	2024-11-20 10:31:36.831046	35
921	2	2024-11-20 10:31:44.253964	38
922	4	2024-11-20 10:31:45.54221	38
923	1	2024-11-20 10:31:50.685889	37
924	7	2024-11-20 10:31:57.600767	35
925	5	2024-11-20 10:32:08.347151	35
926	2	2024-11-20 10:32:15.490371	37
927	4	2024-11-20 10:32:16.728345	38
928	1	2024-11-20 10:32:21.900016	46
929	7	2024-11-20 10:32:28.832501	35
930	5	2024-11-20 10:32:39.581759	35
931	2	2024-11-20 10:32:46.851877	37
932	4	2024-11-20 10:32:47.905476	39
933	1	2024-11-20 10:32:53.079538	37
934	7	2024-11-20 10:33:00.068656	36
935	5	2024-11-20 10:33:10.835125	36
936	4	2024-11-20 10:33:19.119783	38
937	1	2024-11-20 10:33:24.337837	37
938	2	2024-11-20 10:33:25.149625	37
939	7	2024-11-20 10:33:31.304529	35
940	5	2024-11-20 10:33:42.204588	35
941	4	2024-11-20 10:33:50.778939	38
942	1	2024-11-20 10:33:55.868951	37
943	7	2024-11-20 10:34:03.861849	35
944	5	2024-11-20 10:34:13.568157	35
945	2	2024-11-20 10:34:17.16499	38
946	4	2024-11-20 10:34:22.315085	38
947	1	2024-11-20 10:34:27.410198	38
948	7	2024-11-20 10:34:36.414164	36
949	5	2024-11-20 10:34:46.041498	35
950	4	2024-11-20 10:34:53.827908	38
951	1	2024-11-20 10:34:58.969711	36
952	7	2024-11-20 10:35:07.955334	35
953	5	2024-11-20 10:35:17.601811	35
954	4	2024-11-20 10:35:25.073868	38
955	1	2024-11-20 10:35:30.518716	37
956	7	2024-11-20 10:35:39.503437	36
957	5	2024-11-20 10:35:48.85241	35
958	4	2024-11-20 10:35:56.767536	38
959	2	2024-11-20 10:35:58.95224	37
960	1	2024-11-20 10:36:02.032608	37
961	7	2024-11-20 10:36:10.708044	36
962	5	2024-11-20 10:36:20.459461	35
963	4	2024-11-20 10:36:28.263379	38
964	2	2024-11-20 10:36:30.084491	38
965	1	2024-11-20 10:36:33.566244	36
966	7	2024-11-20 10:36:41.956943	36
967	5	2024-11-20 10:36:52.072112	35
968	4	2024-11-20 10:36:59.804238	39
969	2	2024-11-20 10:37:01.627352	37
970	1	2024-11-20 10:37:04.770489	36
971	7	2024-11-20 10:37:13.186498	36
972	5	2024-11-20 10:37:23.644445	35
973	4	2024-11-20 10:37:31.035669	38
974	2	2024-11-20 10:37:33.153297	37
975	1	2024-11-20 10:37:36.023616	37
976	7	2024-11-20 10:37:44.419768	36
977	5	2024-11-20 10:37:54.870353	35
978	4	2024-11-20 10:38:02.442297	39
979	2	2024-11-20 10:38:04.406761	38
980	1	2024-11-20 10:38:07.293713	48
981	7	2024-11-20 10:38:15.95625	35
982	5	2024-11-20 10:38:26.405396	48
983	4	2024-11-20 10:38:33.98419	67
984	2	2024-11-20 10:38:36.028378	37
985	1	2024-11-20 10:38:38.48412	48
986	7	2024-11-20 10:38:47.494853	35
987	5	2024-11-20 10:38:57.79032	47
988	4	2024-11-20 10:39:05.51758	67
989	2	2024-11-20 10:39:07.564894	37
990	1	2024-11-20 10:39:10.045159	48
991	7	2024-11-20 10:39:18.715417	35
992	5	2024-11-20 10:39:29.062325	46
993	4	2024-11-20 10:39:36.71	67
994	2	2024-11-20 10:39:39.490111	37
995	1	2024-11-20 10:39:42.590394	48
996	7	2024-11-20 10:39:50.171158	36
997	5	2024-11-20 10:40:00.671237	45
998	4	2024-11-20 10:40:08.191959	67
999	2	2024-11-20 10:40:10.71569	37
1000	1	2024-11-20 10:40:13.778355	48
1001	7	2024-11-20 10:40:21.707138	35
1002	5	2024-11-20 10:40:32.160555	43
1003	2	2024-11-20 10:40:42.220798	37
1004	1	2024-11-20 10:40:45.082766	48
1005	7	2024-11-20 10:40:53.103422	36
1006	5	2024-11-20 10:41:03.702071	43
1007	4	2024-11-20 10:41:10.953135	67
1008	2	2024-11-20 10:41:13.441295	37
1009	1	2024-11-20 10:41:16.593126	48
1010	7	2024-11-20 10:41:24.378529	35
1011	5	2024-11-20 10:41:35.237704	42
1012	4	2024-11-20 10:41:42.20394	67
1013	1	2024-11-20 10:41:48.13368	48
1014	7	2024-11-20 10:41:55.918987	35
1015	5	2024-11-20 10:42:06.483216	42
1016	4	2024-11-20 10:42:13.533714	67
1017	1	2024-11-20 10:42:19.358802	48
1018	7	2024-11-20 10:42:27.456289	36
1019	5	2024-11-20 10:42:37.700351	40
1020	1	2024-11-20 10:42:50.634507	48
1021	2	2024-11-20 10:42:54.703747	67
1022	7	2024-11-20 10:42:58.660572	36
1023	5	2024-11-20 10:43:09.277039	40
1024	1	2024-11-20 10:43:21.847356	48
1025	2	2024-11-20 10:43:25.814586	65
1026	7	2024-11-20 10:43:29.945974	35
1027	4	2024-11-20 10:43:43.438688	100
1028	1	2024-11-20 10:43:53.486929	48
1029	2	2024-11-20 10:43:57.180211	65
1030	7	2024-11-20 10:44:01.161276	36
1031	5	2024-11-20 10:44:11.778574	40
1032	7	2024-11-20 10:44:17.030096	35
1033	4	2024-11-20 10:44:17.857519	0
1034	1	2024-11-20 10:44:24.701084	48
1035	2	2024-11-20 10:44:28.360015	65
1036	5	2024-11-20 10:44:43.012512	40
1037	7	2024-11-20 10:44:48.571365	35
1038	4	2024-11-20 10:44:48.980404	38
1039	1	2024-11-20 10:44:55.955155	48
1040	2	2024-11-20 10:44:59.839723	65
1041	5	2024-11-20 10:45:14.290204	40
1042	4	2024-11-20 10:45:20.200986	38
1043	7	2024-11-20 10:45:20.32286	35
1044	1	2024-11-20 10:45:27.693841	48
1045	2	2024-11-20 10:45:31.047278	65
1046	5	2024-11-20 10:45:45.952713	39
1047	7	2024-11-20 10:45:51.862143	35
1048	4	2024-11-20 10:45:51.863214	38
1049	1	2024-11-20 10:45:59.279167	48
1050	2	2024-11-20 10:46:02.216793	65
1051	5	2024-11-20 10:46:17.22137	39
1052	7	2024-11-20 10:46:23.101118	35
1053	4	2024-11-20 10:46:23.102215	38
1054	1	2024-11-20 10:46:30.516622	48
1055	2	2024-11-20 10:46:33.415857	65
1056	5	2024-11-20 10:46:48.907852	39
1057	1	2024-11-20 10:47:01.806378	48
1058	2	2024-11-20 10:47:04.588493	65
1059	5	2024-11-20 10:47:20.141613	39
1060	7	2024-11-20 10:47:26.265329	35
1061	4	2024-11-20 10:47:27.90658	37
1062	1	2024-11-20 10:47:32.980445	48
1063	2	2024-11-20 10:47:35.794771	65
1064	5	2024-11-20 10:47:51.763956	40
1065	7	2024-11-20 10:47:57.803342	36
1066	4	2024-11-20 10:47:59.560718	37
1067	1	2024-11-20 10:48:04.229642	47
1068	2	2024-11-20 10:48:06.986791	65
1069	5	2024-11-20 10:48:23.028105	39
1070	7	2024-11-20 10:48:29.019817	36
1071	4	2024-11-20 10:48:31.807646	37
1072	1	2024-11-20 10:48:35.772786	48
1073	2	2024-11-20 10:48:38.356864	65
1074	5	2024-11-20 10:48:54.781693	40
1075	7	2024-11-20 10:49:00.275813	35
1076	4	2024-11-20 10:49:03.088499	37
1077	1	2024-11-20 10:49:06.971095	48
1078	2	2024-11-20 10:49:09.901855	65
1079	5	2024-11-20 10:49:26.017225	39
1080	7	2024-11-20 10:49:31.810219	35
1081	4	2024-11-20 10:49:34.298903	37
1082	1	2024-11-20 10:49:38.255819	48
1083	2	2024-11-20 10:49:41.092411	65
1084	5	2024-11-20 10:49:57.29765	39
1085	7	2024-11-20 10:50:03.570963	36
1086	4	2024-11-20 10:50:06.013979	38
1087	1	2024-11-20 10:50:09.746335	48
1088	2	2024-11-20 10:50:12.402347	65
1089	5	2024-11-20 10:50:28.616174	39
1090	7	2024-11-20 10:50:34.817119	35
1091	4	2024-11-20 10:50:37.556523	37
1092	1	2024-11-20 10:50:40.958542	48
1093	2	2024-11-20 10:50:43.921115	65
1094	5	2024-11-20 10:51:01.184014	39
1095	7	2024-11-20 10:51:06.427382	35
1096	4	2024-11-20 10:51:08.778813	37
1097	1	2024-11-20 10:51:12.636664	48
1098	2	2024-11-20 10:51:15.125491	64
1099	5	2024-11-20 10:51:32.424616	40
1100	7	2024-11-20 10:51:37.648177	35
1101	4	2024-11-20 10:51:40.013872	38
1102	1	2024-11-20 10:51:43.844826	48
1103	2	2024-11-20 10:51:46.300207	65
1104	7	2024-11-20 10:52:08.861748	36
1105	4	2024-11-20 10:52:11.792345	37
1106	5	2024-11-20 10:52:13.739922	39
1107	1	2024-11-20 10:52:15.046015	48
1108	2	2024-11-20 10:52:18.938234	65
1109	7	2024-11-20 10:52:40.104679	35
1110	4	2024-11-20 10:52:42.997638	37
1111	5	2024-11-20 10:52:45.122239	39
1112	1	2024-11-20 10:52:48.64752	48
1113	2	2024-11-20 10:52:50.116376	65
1114	7	2024-11-20 10:53:11.363166	35
1115	4	2024-11-20 10:53:14.223968	38
1116	5	2024-11-20 10:53:16.360047	39
1117	1	2024-11-20 10:53:19.944967	47
1118	2	2024-11-20 10:53:21.297208	64
1119	7	2024-11-20 10:53:42.543203	35
1120	4	2024-11-20 10:53:45.969895	37
1121	5	2024-11-20 10:53:47.854769	39
1122	1	2024-11-20 10:53:51.117922	48
1123	2	2024-11-20 10:53:52.462908	65
1124	7	2024-11-20 10:54:14.023993	35
1125	4	2024-11-20 10:54:17.505048	38
1126	5	2024-11-20 10:54:19.376611	39
1127	1	2024-11-20 10:54:22.353152	48
1128	2	2024-11-20 10:54:24.062539	65
1129	7	2024-11-20 10:54:45.564238	35
1130	4	2024-11-20 10:54:48.748942	38
1131	5	2024-11-20 10:54:50.907563	39
1132	1	2024-11-20 10:54:53.971492	48
1133	2	2024-11-20 10:54:57.654858	65
1134	7	2024-11-20 10:55:17.102967	35
1135	4	2024-11-20 10:55:21.019047	37
1136	5	2024-11-20 10:55:22.430566	39
1137	1	2024-11-20 10:55:25.176331	48
1138	2	2024-11-20 10:55:29.187155	65
1139	7	2024-11-20 10:55:48.642342	35
1140	4	2024-11-20 10:55:52.325257	37
1141	5	2024-11-20 10:55:53.694925	39
1142	1	2024-11-20 10:55:56.539457	48
496	20	2024-11-19 16:18:10.544347	40
1143	2	2024-11-20 10:56:00.727733	65
1144	7	2024-11-20 10:56:20.212622	35
1145	4	2024-11-20 10:56:24.903631	37
1146	5	2024-11-20 10:56:24.964725	39
1147	1	2024-11-20 10:56:28.187035	48
1148	2	2024-11-20 10:56:32.264782	65
1149	7	2024-11-20 10:56:51.728565	35
1150	5	2024-11-20 10:56:56.23774	39
1151	4	2024-11-20 10:56:56.634231	38
1152	2	2024-11-20 10:57:03.804109	65
1153	1	2024-11-20 10:57:04.842742	48
1154	7	2024-11-20 10:57:23.262051	35
1155	5	2024-11-20 10:57:27.571317	39
1156	4	2024-11-20 10:57:29.209964	37
1157	2	2024-11-20 10:57:35.344488	65
1158	1	2024-11-20 10:57:38.423414	48
1159	7	2024-11-20 10:57:54.808557	35
1160	5	2024-11-20 10:57:58.853325	39
1161	4	2024-11-20 10:58:00.740959	38
1162	2	2024-11-20 10:58:06.883725	65
1163	1	2024-11-20 10:58:10.059098	48
1164	7	2024-11-20 10:58:26.345334	35
1165	4	2024-11-20 10:58:33.317295	38
1166	5	2024-11-20 10:58:34.220655	39
1167	2	2024-11-20 10:58:40.510878	65
1168	1	2024-11-20 10:58:45.783658	48
1169	7	2024-11-20 10:58:58.018528	35
1170	4	2024-11-20 10:59:04.586684	37
1171	5	2024-11-20 10:59:05.924854	39
1172	2	2024-11-20 10:59:11.799774	65
1173	1	2024-11-20 10:59:17.346977	48
1174	7	2024-11-20 10:59:29.315007	35
1175	4	2024-11-20 10:59:35.859259	37
1176	5	2024-11-20 10:59:37.223361	39
1177	2	2024-11-20 10:59:43.095742	64
1178	7	2024-11-20 11:00:00.614931	35
1179	4	2024-11-20 11:00:07.157888	38
1180	5	2024-11-20 11:00:08.512241	39
1181	2	2024-11-20 11:00:14.500454	65
1182	7	2024-11-20 11:00:32.103872	35
1183	4	2024-11-20 11:00:38.434584	38
1184	5	2024-11-20 11:00:39.772196	39
1185	2	2024-11-20 11:00:46.02692	65
1186	7	2024-11-20 11:01:03.624412	35
1187	5	2024-11-20 11:01:10.998809	39
1188	4	2024-11-20 11:01:12.100706	37
1189	2	2024-11-20 11:01:17.216527	65
1190	7	2024-11-20 11:01:35.160332	35
1191	5	2024-11-20 11:01:42.59128	39
1192	4	2024-11-20 11:01:43.334826	37
1193	2	2024-11-20 11:01:48.482943	65
1194	7	2024-11-20 11:02:06.722914	35
1195	5	2024-11-20 11:02:13.9322	39
1196	4	2024-11-20 11:02:14.629524	37
1197	2	2024-11-20 11:02:20.439664	65
1198	7	2024-11-20 11:02:38.277765	35
1199	5	2024-11-20 11:02:45.156149	39
1200	4	2024-11-20 11:02:45.852022	37
1201	2	2024-11-20 11:02:51.668517	65
1202	7	2024-11-20 11:03:09.493822	35
1203	5	2024-11-20 11:03:16.43897	39
1204	4	2024-11-20 11:03:17.368408	37
1205	2	2024-11-20 11:03:23.089316	65
1206	7	2024-11-20 11:03:40.692514	35
1207	5	2024-11-20 11:03:47.674407	39
1208	4	2024-11-20 11:03:48.895391	38
1209	2	2024-11-20 11:03:54.629614	64
1210	7	2024-11-20 11:04:12.241849	35
1211	5	2024-11-20 11:04:18.918841	39
1212	4	2024-11-20 11:04:20.434522	38
1213	2	2024-11-20 11:04:26.272113	65
1214	7	2024-11-20 11:04:43.819056	35
1215	5	2024-11-20 11:04:50.577105	39
1216	4	2024-11-20 11:04:51.986316	38
1217	2	2024-11-20 11:04:57.507452	65
1218	7	2024-11-20 11:05:15.320597	35
1219	5	2024-11-20 11:05:21.905351	39
1220	4	2024-11-20 11:05:23.515298	37
1221	2	2024-11-20 11:05:28.72045	65
1222	7	2024-11-20 11:05:46.538583	35
1223	5	2024-11-20 11:05:53.423489	39
1224	4	2024-11-20 11:05:54.742195	38
1225	2	2024-11-20 11:06:00.17369	65
1226	7	2024-11-20 11:06:17.918403	35
1227	5	2024-11-20 11:06:24.726822	38
1228	4	2024-11-20 11:06:28.230426	37
1229	2	2024-11-20 11:06:31.71488	65
1230	7	2024-11-20 11:06:49.121298	35
1231	5	2024-11-20 11:06:56.292804	38
1232	4	2024-11-20 11:06:59.81293	38
1233	2	2024-11-20 11:07:03.251209	65
1234	7	2024-11-20 11:07:21.061215	35
1235	5	2024-11-20 11:07:28.881773	38
1236	4	2024-11-20 11:07:31.313898	38
1237	2	2024-11-20 11:07:34.437765	65
1238	7	2024-11-20 11:07:52.601754	35
1239	5	2024-11-20 11:08:00.391937	38
1240	4	2024-11-20 11:08:02.909656	37
1241	2	2024-11-20 11:08:05.957707	65
1242	7	2024-11-20 11:08:24.148281	35
1243	5	2024-11-20 11:08:31.940274	38
1244	4	2024-11-20 11:08:34.387906	38
1245	2	2024-11-20 11:08:37.164021	65
1246	7	2024-11-20 11:08:55.688089	35
1247	5	2024-11-20 11:09:03.470945	38
1248	4	2024-11-20 11:09:05.930076	37
1249	2	2024-11-20 11:09:08.398598	65
1250	7	2024-11-20 11:09:27.226834	35
1251	5	2024-11-20 11:09:37.089608	38
1252	4	2024-11-20 11:09:37.14945	38
1253	2	2024-11-20 11:09:39.936643	65
1254	7	2024-11-20 11:09:58.449805	35
1255	4	2024-11-20 11:10:08.393882	37
1256	5	2024-11-20 11:10:08.439583	39
1257	2	2024-11-20 11:10:11.464712	65
1258	7	2024-11-20 11:10:29.762028	35
1259	5	2024-11-20 11:10:39.739422	38
1260	4	2024-11-20 11:10:39.929503	37
1261	2	2024-11-20 11:10:42.645536	65
1262	7	2024-11-20 11:11:01.224082	35
1263	5	2024-11-20 11:11:11.263873	38
1264	4	2024-11-20 11:11:11.500071	37
1265	2	2024-11-20 11:11:14.153563	65
1266	7	2024-11-20 11:11:32.763323	35
1267	4	2024-11-20 11:11:42.678597	38
1268	5	2024-11-20 11:11:42.809438	39
1269	2	2024-11-20 11:11:45.665521	65
1270	7	2024-11-20 11:12:04.30429	35
1271	5	2024-11-20 11:12:14.361899	38
1272	4	2024-11-20 11:12:16.181919	38
1273	2	2024-11-20 11:12:17.111945	65
1274	7	2024-11-20 11:12:35.859899	35
1275	5	2024-11-20 11:12:45.882619	39
1276	4	2024-11-20 11:12:47.738988	37
1277	2	2024-11-20 11:12:48.65898	65
1278	7	2024-11-20 11:13:07.076903	35
1279	5	2024-11-20 11:13:17.441779	39
1280	4	2024-11-20 11:13:18.93073	37
1281	2	2024-11-20 11:13:20.189403	65
1282	7	2024-11-20 11:13:38.352332	35
1283	5	2024-11-20 11:13:48.755645	39
1284	4	2024-11-20 11:13:50.40048	38
1285	2	2024-11-20 11:13:51.636084	65
1286	7	2024-11-20 11:14:09.853374	35
1287	5	2024-11-20 11:14:20.315665	39
1288	4	2024-11-20 11:14:21.952545	37
1289	2	2024-11-20 11:14:22.853398	65
1290	7	2024-11-20 11:14:41.425383	35
1291	5	2024-11-20 11:14:51.786201	38
1292	4	2024-11-20 11:14:53.475134	37
1293	2	2024-11-20 11:14:55.328659	65
1294	7	2024-11-20 11:15:12.948086	35
1295	5	2024-11-20 11:15:23.188311	39
1296	4	2024-11-20 11:15:24.678397	37
1297	2	2024-11-20 11:15:26.509624	65
1298	7	2024-11-20 11:15:44.472846	35
1299	5	2024-11-20 11:15:54.529671	39
1300	4	2024-11-20 11:15:56.160074	38
1301	2	2024-11-20 11:15:57.992791	65
1302	7	2024-11-20 11:16:15.753323	35
1303	5	2024-11-20 11:16:26.245067	39
1304	4	2024-11-20 11:16:27.378496	38
1305	2	2024-11-20 11:16:29.429756	65
1306	7	2024-11-20 11:16:46.956075	35
1307	5	2024-11-20 11:16:57.668244	39
1308	4	2024-11-20 11:16:58.605176	38
1309	2	2024-11-20 11:17:02.921516	65
1310	7	2024-11-20 11:17:18.484158	35
1311	5	2024-11-20 11:17:28.986143	39
1312	4	2024-11-20 11:17:30.182274	38
1313	2	2024-11-20 11:17:34.457767	65
1314	7	2024-11-20 11:17:49.720087	54
1315	5	2024-11-20 11:18:00.293284	39
1316	4	2024-11-20 11:18:01.701578	88
1317	2	2024-11-20 11:18:05.99748	65
1318	7	2024-11-20 11:18:20.952653	59
1319	4	2024-11-20 11:18:33.240004	100
1320	5	2024-11-20 11:18:33.876248	39
1321	2	2024-11-20 11:18:37.556008	65
1322	7	2024-11-20 11:18:52.177234	92
1323	5	2024-11-20 11:19:05.427951	38
1324	4	2024-11-20 11:19:06.462839	69
1325	2	2024-11-20 11:19:09.083427	65
1326	7	2024-11-20 11:19:23.414732	66
1327	5	2024-11-20 11:19:36.919256	39
1328	4	2024-11-20 11:19:37.960172	38
1329	2	2024-11-20 11:19:40.270402	65
1330	7	2024-11-20 11:19:54.618346	35
1331	5	2024-11-20 11:20:08.54041	39
1332	4	2024-11-20 11:20:09.510102	38
1333	2	2024-11-20 11:20:11.469641	65
1334	7	2024-11-20 11:20:25.887061	36
1335	5	2024-11-20 11:20:40.277854	39
1336	4	2024-11-20 11:20:40.719816	37
1337	2	2024-11-20 11:20:42.743773	65
1338	7	2024-11-20 11:20:57.421072	36
1339	5	2024-11-20 11:21:11.550491	39
1340	4	2024-11-20 11:21:11.960396	38
1341	2	2024-11-20 11:21:14.216152	65
1342	7	2024-11-20 11:21:28.963468	36
1343	4	2024-11-20 11:21:43.195397	38
1344	5	2024-11-20 11:21:45.15512	39
1345	2	2024-11-20 11:21:45.756375	65
1346	7	2024-11-20 11:22:00.501124	36
1347	4	2024-11-20 11:22:14.429174	37
1348	5	2024-11-20 11:22:16.455233	39
1349	2	2024-11-20 11:22:17.298207	65
1350	7	2024-11-20 11:22:32.052617	36
1351	4	2024-11-20 11:22:48.032263	37
1352	5	2024-11-20 11:22:48.034291	39
1353	2	2024-11-20 11:22:48.851281	65
1354	7	2024-11-20 11:23:03.484218	36
1355	4	2024-11-20 11:23:19.56269	38
1356	5	2024-11-20 11:23:19.888714	39
1357	2	2024-11-20 11:23:20.640347	65
1358	7	2024-11-20 11:23:36.807467	36
1359	5	2024-11-20 11:23:51.623517	39
1360	4	2024-11-20 11:23:52.181896	37
1361	2	2024-11-20 11:23:53.148337	65
1362	7	2024-11-20 11:24:08.512627	36
1363	4	2024-11-20 11:24:23.973709	38
1364	5	2024-11-20 11:24:24.289091	39
1365	2	2024-11-20 11:24:24.844852	65
1366	7	2024-11-20 11:24:40.152775	36
1367	4	2024-11-20 11:24:55.464737	37
1368	2	2024-11-20 11:24:56.480854	65
1369	5	2024-11-20 11:24:58.996909	39
1370	7	2024-11-20 11:25:11.815347	35
1371	4	2024-11-20 11:25:27.174601	38
1372	2	2024-11-20 11:25:27.776745	65
1373	5	2024-11-20 11:25:30.628756	39
1374	7	2024-11-20 11:25:45.398042	36
1375	4	2024-11-20 11:25:58.511457	37
1376	2	2024-11-20 11:25:59.319508	65
1377	5	2024-11-20 11:26:01.77049	39
1378	7	2024-11-20 11:26:16.73671	36
1379	2	2024-11-20 11:26:30.88994	65
1380	4	2024-11-20 11:26:32.154197	37
1381	5	2024-11-20 11:26:34.440881	39
1382	7	2024-11-20 11:26:48.258749	36
1383	2	2024-11-20 11:27:02.390701	65
1384	4	2024-11-20 11:27:04.435033	38
1385	5	2024-11-20 11:27:06.088195	39
1386	7	2024-11-20 11:27:19.79279	56
1387	2	2024-11-20 11:27:33.931948	65
1388	4	2024-11-20 11:27:35.979941	40
1389	5	2024-11-20 11:27:37.65684	35
1390	7	2024-11-20 11:27:51.338395	36
1391	2	2024-11-20 11:28:05.475026	66
1392	4	2024-11-20 11:28:07.182726	55
1393	5	2024-11-20 11:28:09.022153	36
1394	7	2024-11-20 11:28:22.585097	36
1395	2	2024-11-20 11:28:36.673939	65
1396	4	2024-11-20 11:28:38.856299	37
1397	5	2024-11-20 11:28:40.242108	46
1398	7	2024-11-20 11:28:54.239015	36
1399	2	2024-11-20 11:29:08.148294	65
1400	4	2024-11-20 11:29:10.386918	38
1401	5	2024-11-20 11:29:11.825517	46
1402	7	2024-11-20 11:29:25.748576	36
1403	2	2024-11-20 11:29:39.68335	65
1404	4	2024-11-20 11:29:41.924308	38
1405	5	2024-11-20 11:29:43.076917	47
1406	7	2024-11-20 11:29:57.292293	36
1407	2	2024-11-20 11:30:10.952038	65
1408	4	2024-11-20 11:30:13.112151	37
1409	5	2024-11-20 11:30:14.319535	46
1410	7	2024-11-20 11:30:28.549221	36
1411	2	2024-11-20 11:30:42.751663	65
1412	4	2024-11-20 11:30:44.401572	38
1413	5	2024-11-20 11:30:45.832856	46
1414	7	2024-11-20 11:31:00.361596	36
1415	2	2024-11-20 11:31:14.32733	65
1416	4	2024-11-20 11:31:15.930936	38
1417	5	2024-11-20 11:31:17.125864	46
1418	7	2024-11-20 11:31:31.907707	36
1419	2	2024-11-20 11:31:45.520346	65
1420	4	2024-11-20 11:31:47.20135	38
1421	5	2024-11-20 11:31:50.402209	46
1422	7	2024-11-20 11:32:03.140938	36
1423	2	2024-11-20 11:32:16.729889	65
1424	4	2024-11-20 11:32:18.85534	38
1425	5	2024-11-20 11:32:22.323893	46
1426	7	2024-11-20 11:32:34.385639	36
1427	2	2024-11-20 11:32:48.564896	65
1428	4	2024-11-20 11:32:50.377678	38
1429	5	2024-11-20 11:32:53.698112	46
1430	7	2024-11-20 11:33:06.133196	36
1431	2	2024-11-20 11:33:19.838619	65
1432	4	2024-11-20 11:33:21.592543	38
1433	5	2024-11-20 11:33:25.059736	46
1434	7	2024-11-20 11:33:37.690175	36
1435	2	2024-11-20 11:33:51.37242	65
1436	4	2024-11-20 11:33:52.866614	38
1437	5	2024-11-20 11:33:56.39366	46
1438	7	2024-11-20 11:34:08.982723	36
1439	2	2024-11-20 11:34:22.558034	65
1440	4	2024-11-20 11:34:24.248863	38
1441	5	2024-11-20 11:34:27.734798	46
1442	7	2024-11-20 11:34:41.406647	36
1443	2	2024-11-20 11:34:53.866505	65
1444	4	2024-11-20 11:34:55.478711	38
1445	5	2024-11-20 11:34:58.974418	46
1446	7	2024-11-20 11:35:12.723108	36
1447	2	2024-11-20 11:35:25.107125	65
1448	4	2024-11-20 11:35:27.155593	38
1449	5	2024-11-20 11:35:30.669544	46
1450	7	2024-11-20 11:35:44.221499	36
1451	2	2024-11-20 11:35:56.721389	65
1452	4	2024-11-20 11:35:58.783391	38
1453	5	2024-11-20 11:36:01.923614	46
1454	7	2024-11-20 11:36:19.477089	36
1455	4	2024-11-20 11:36:30.124784	38
1456	2	2024-11-20 11:36:32.363948	65
1457	5	2024-11-20 11:36:33.230562	46
1458	7	2024-11-20 11:36:50.778417	36
1459	4	2024-11-20 11:37:01.64241	38
1460	2	2024-11-20 11:37:03.626288	65
1461	5	2024-11-20 11:37:04.532156	46
1462	7	2024-11-20 11:37:22.370942	36
1463	4	2024-11-20 11:37:33.173851	38
1464	2	2024-11-20 11:37:34.86045	65
1465	5	2024-11-20 11:37:35.877376	46
1466	7	2024-11-20 11:37:55.906038	36
1467	4	2024-11-20 11:38:04.411967	38
1468	2	2024-11-20 11:38:06.22243	65
1469	5	2024-11-20 11:38:07.240231	46
1470	7	2024-11-20 11:38:27.462832	36
1471	4	2024-11-20 11:38:35.638635	38
1472	2	2024-11-20 11:38:37.428616	65
1473	5	2024-11-20 11:38:38.581034	46
1474	7	2024-11-20 11:38:58.676583	36
1475	4	2024-11-20 11:39:06.859302	38
1476	5	2024-11-20 11:39:10.347919	46
1477	2	2024-11-20 11:39:10.781992	65
1478	7	2024-11-20 11:39:29.926406	36
1479	4	2024-11-20 11:39:38.102611	37
1480	5	2024-11-20 11:39:41.625793	46
1481	2	2024-11-20 11:39:42.45026	65
1482	7	2024-11-20 11:40:01.171424	36
1483	4	2024-11-20 11:40:09.688471	38
1484	5	2024-11-20 11:40:12.843203	46
1485	2	2024-11-20 11:40:13.949707	65
1486	7	2024-11-20 11:40:32.387537	36
1487	4	2024-11-20 11:40:42.84506	38
1488	5	2024-11-20 11:40:44.546092	46
1489	2	2024-11-20 11:40:45.500779	65
1490	7	2024-11-20 11:41:03.625769	36
1491	4	2024-11-20 11:41:14.36549	38
1492	5	2024-11-20 11:41:15.855528	46
1493	2	2024-11-20 11:41:16.771187	65
1494	7	2024-11-20 11:41:35.250485	36
1495	4	2024-11-20 11:41:47.583124	38
1496	2	2024-11-20 11:41:47.94098	65
1497	5	2024-11-20 11:41:50.413959	46
1498	7	2024-11-20 11:42:06.802427	36
1499	4	2024-11-20 11:42:19.115697	37
1500	2	2024-11-20 11:42:19.12981	65
1501	5	2024-11-20 11:42:21.791055	46
1502	7	2024-11-20 11:42:38.328448	36
1503	2	2024-11-20 11:42:50.436301	65
1504	4	2024-11-20 11:42:50.437454	38
1505	5	2024-11-20 11:42:53.062982	46
1506	7	2024-11-20 11:43:09.542593	36
1507	2	2024-11-20 11:43:21.630883	65
1508	4	2024-11-20 11:43:21.637589	37
1509	5	2024-11-20 11:43:24.696763	46
1510	7	2024-11-20 11:43:40.797704	36
1511	2	2024-11-20 11:43:52.826668	65
1512	4	2024-11-20 11:43:52.872377	37
1513	5	2024-11-20 11:43:55.940148	46
1514	7	2024-11-20 11:44:12.027035	36
1515	4	2024-11-20 11:44:24.41886	38
1516	2	2024-11-20 11:44:24.421984	65
1517	5	2024-11-20 11:44:27.509397	45
1518	7	2024-11-20 11:44:43.236885	36
1519	2	2024-11-20 11:44:55.607534	65
1520	4	2024-11-20 11:44:55.680974	38
1521	5	2024-11-20 11:44:58.781201	46
1522	7	2024-11-20 11:45:14.806113	36
1523	2	2024-11-20 11:45:26.884686	65
1524	4	2024-11-20 11:45:27.287099	38
1525	5	2024-11-20 11:45:30.586762	46
1526	7	2024-11-20 11:45:46.055606	36
1527	2	2024-11-20 11:45:58.089144	65
1528	4	2024-11-20 11:45:58.530368	38
1529	5	2024-11-20 11:46:01.845425	46
1530	7	2024-11-20 11:46:17.875119	36
1531	2	2024-11-20 11:46:29.748054	65
1532	4	2024-11-20 11:46:29.958173	38
1533	5	2024-11-20 11:46:33.319332	45
1534	7	2024-11-20 11:46:49.418417	36
1535	2	2024-11-20 11:47:01.289427	65
1536	4	2024-11-20 11:47:01.495222	38
1537	5	2024-11-20 11:47:04.794222	45
1538	7	2024-11-20 11:47:20.672381	36
1539	2	2024-11-20 11:47:32.476618	65
1540	4	2024-11-20 11:47:32.685174	37
1541	5	2024-11-20 11:47:36.054798	45
1542	7	2024-11-20 11:47:52.290263	36
1543	2	2024-11-20 11:48:03.962052	65
1544	5	2024-11-20 11:48:07.332138	45
1545	4	2024-11-20 11:48:08.277937	38
1546	7	2024-11-20 11:48:23.523872	36
1547	2	2024-11-20 11:48:35.157468	65
1548	5	2024-11-20 11:48:38.604334	45
1549	4	2024-11-20 11:48:39.57085	38
1550	7	2024-11-20 11:48:54.72656	36
1551	2	2024-11-20 11:49:06.486417	65
1552	5	2024-11-20 11:49:09.856465	46
1553	4	2024-11-20 11:49:10.740169	38
1554	7	2024-11-20 11:49:26.317656	36
1555	2	2024-11-20 11:49:38.188396	65
1556	5	2024-11-20 11:49:41.464218	45
1557	4	2024-11-20 11:49:41.999914	38
1558	7	2024-11-20 11:49:57.837677	36
1559	2	2024-11-20 11:50:09.459361	65
1560	5	2024-11-20 11:50:12.71947	45
1561	4	2024-11-20 11:50:13.208658	38
1562	7	2024-11-20 11:50:29.369503	36
1563	2	2024-11-20 11:50:40.636241	65
1564	5	2024-11-20 11:50:44.33603	45
1565	4	2024-11-20 11:50:46.889518	40
1566	7	2024-11-20 11:51:00.911838	69
1567	2	2024-11-20 11:51:12.175015	65
1568	5	2024-11-20 11:51:15.689696	46
1569	4	2024-11-20 11:51:18.115087	40
1570	7	2024-11-20 11:51:32.472487	64
1571	2	2024-11-20 11:51:43.73269	65
1572	5	2024-11-20 11:51:46.970647	45
1573	4	2024-11-20 11:51:49.342903	40
1574	7	2024-11-20 11:52:03.989765	63
1575	2	2024-11-20 11:52:15.271798	64
1576	5	2024-11-20 11:52:18.648224	64
1577	4	2024-11-20 11:52:20.600755	40
1578	7	2024-11-20 11:52:35.530787	63
1579	2	2024-11-20 11:52:46.565871	65
1580	5	2024-11-20 11:52:50.290315	63
1581	4	2024-11-20 11:52:53.150626	40
1582	7	2024-11-20 11:53:06.751362	63
1583	2	2024-11-20 11:53:19.979288	66
1584	5	2024-11-20 11:53:21.822578	63
1585	4	2024-11-20 11:53:24.709975	40
1586	7	2024-11-20 11:53:37.999069	62
1587	2	2024-11-20 11:53:51.209349	65
1588	5	2024-11-20 11:53:53.410156	63
1589	4	2024-11-20 11:53:56.257292	75
1590	7	2024-11-20 11:54:09.626495	62
1591	2	2024-11-20 11:54:22.431765	65
1592	5	2024-11-20 11:54:25.950209	63
1593	4	2024-11-20 11:54:27.77606	68
1594	7	2024-11-20 11:54:41.086988	62
1595	2	2024-11-20 11:54:53.979329	65
1596	5	2024-11-20 11:54:57.509947	63
1597	4	2024-11-20 11:54:59.300288	53
1598	7	2024-11-20 11:55:12.612785	62
1599	2	2024-11-20 11:55:25.184219	65
1600	5	2024-11-20 11:55:29.016664	63
1601	4	2024-11-20 11:55:30.490356	44
1602	7	2024-11-20 11:55:44.356801	62
1603	2	2024-11-20 11:55:56.649987	65
1604	5	2024-11-20 11:56:00.347267	63
1605	4	2024-11-20 11:56:01.982747	44
1606	7	2024-11-20 11:56:15.90682	61
1607	2	2024-11-20 11:56:27.923419	65
1608	5	2024-11-20 11:56:31.648773	64
1609	4	2024-11-20 11:56:33.544448	43
1610	7	2024-11-20 11:56:47.448457	54
1611	2	2024-11-20 11:56:59.339136	65
1612	5	2024-11-20 11:57:03.431801	36
1613	4	2024-11-20 11:57:04.794914	37
1614	7	2024-11-20 11:57:18.760757	36
1615	2	2024-11-20 11:57:30.856451	65
1616	5	2024-11-20 11:57:34.815301	51
1617	4	2024-11-20 11:57:36.185293	56
1618	7	2024-11-20 11:57:50.31209	0
1619	2	2024-11-20 11:58:02.39358	65
1620	4	2024-11-20 11:58:07.747064	55
1621	5	2024-11-20 11:58:08.142981	51
1622	7	2024-11-20 11:58:21.850969	0
1623	2	2024-11-20 11:58:33.941006	65
1624	4	2024-11-20 11:58:38.995248	55
1625	5	2024-11-20 11:58:39.477571	51
1626	7	2024-11-20 11:58:53.398309	0
1627	2	2024-11-20 11:59:05.498923	65
1628	4	2024-11-20 11:59:10.592247	66
1629	5	2024-11-20 11:59:10.789214	66
1630	7	2024-11-20 11:59:24.933322	56
1631	2	2024-11-20 11:59:37.012183	65
1632	4	2024-11-20 11:59:42.13772	68
1633	5	2024-11-20 11:59:43.026366	66
1634	7	2024-11-20 11:59:56.548525	56
1635	2	2024-11-20 12:00:08.575208	65
1636	4	2024-11-20 12:00:13.390582	38
1637	5	2024-11-20 12:00:14.813872	66
1638	7	2024-11-20 12:00:27.781842	56
1639	2	2024-11-20 12:00:39.73299	65
1640	4	2024-11-20 12:00:44.596023	38
1641	5	2024-11-20 12:00:46.198728	66
1642	7	2024-11-20 12:00:59.031429	56
1643	2	2024-11-20 12:01:10.97768	65
1644	4	2024-11-20 12:01:15.936911	38
1645	5	2024-11-20 12:01:17.528934	66
1646	7	2024-11-20 12:01:30.265194	56
1647	2	2024-11-20 12:01:42.164245	65
1648	4	2024-11-20 12:01:47.170793	38
1649	5	2024-11-20 12:01:48.796415	66
1650	7	2024-11-20 12:02:01.480523	56
1651	2	2024-11-20 12:02:13.739345	65
1652	4	2024-11-20 12:02:18.384905	38
1653	5	2024-11-20 12:02:20.051285	65
1654	7	2024-11-20 12:02:32.683883	56
1655	2	2024-11-20 12:02:45.437743	65
1656	4	2024-11-20 12:02:49.725035	38
1657	5	2024-11-20 12:02:51.642883	65
1658	7	2024-11-20 12:03:04.310821	56
1659	2	2024-11-20 12:03:16.622238	65
1660	4	2024-11-20 12:03:20.918045	38
1661	5	2024-11-20 12:03:22.910721	66
1662	7	2024-11-20 12:03:35.529812	56
1663	2	2024-11-20 12:03:48.098081	65
1664	4	2024-11-20 12:03:52.129192	38
1665	5	2024-11-20 12:03:54.176837	66
1666	7	2024-11-20 12:04:06.955427	56
1667	2	2024-11-20 12:04:19.320938	65
1668	4	2024-11-20 12:04:23.526893	38
1669	5	2024-11-20 12:04:25.818034	66
1670	7	2024-11-20 12:04:38.162274	56
1671	2	2024-11-20 12:04:50.559552	65
1672	4	2024-11-20 12:04:54.735631	38
1673	5	2024-11-20 12:04:57.093873	66
1674	7	2024-11-20 12:05:09.819243	56
1675	2	2024-11-20 12:05:21.786573	65
1676	4	2024-11-20 12:05:26.002584	38
1677	5	2024-11-20 12:05:28.672187	66
1678	7	2024-11-20 12:05:41.038772	56
1679	2	2024-11-20 12:05:53.078217	65
1680	4	2024-11-20 12:05:57.33117	38
1681	5	2024-11-20 12:05:59.919228	66
1682	7	2024-11-20 12:06:12.275098	56
1683	2	2024-11-20 12:06:24.240833	65
1684	4	2024-11-20 12:06:28.552972	38
1685	5	2024-11-20 12:06:31.215994	65
1686	7	2024-11-20 12:06:43.816144	56
1687	2	2024-11-20 12:06:55.698031	65
1688	4	2024-11-20 12:07:00.007981	38
1689	5	2024-11-20 12:07:02.889468	66
1690	7	2024-11-20 12:07:15.357592	56
1691	2	2024-11-20 12:07:27.230674	65
1692	4	2024-11-20 12:07:31.227349	38
1693	5	2024-11-20 12:07:34.41794	65
1694	7	2024-11-20 12:07:46.583524	56
1695	2	2024-11-20 12:07:58.429346	65
1696	4	2024-11-20 12:08:02.484629	38
1697	5	2024-11-20 12:08:05.962941	65
1698	7	2024-11-20 12:08:17.823232	56
1699	2	2024-11-20 12:08:30.930742	65
1700	4	2024-11-20 12:08:34.041911	38
1701	5	2024-11-20 12:08:37.523806	66
1702	7	2024-11-20 12:08:49.045568	56
1703	2	2024-11-20 12:09:02.469782	65
1704	4	2024-11-20 12:09:05.555363	38
1705	5	2024-11-20 12:09:09.035931	65
1706	7	2024-11-20 12:09:20.282627	56
1707	2	2024-11-20 12:09:33.799055	65
1708	4	2024-11-20 12:09:36.765262	38
1709	5	2024-11-20 12:09:40.653862	65
1710	7	2024-11-20 12:09:51.876898	56
1711	2	2024-11-20 12:10:05.454525	65
1712	4	2024-11-20 12:10:08.21601	38
1713	5	2024-11-20 12:10:12.070235	66
1714	7	2024-11-20 12:10:23.363012	56
1715	2	2024-11-20 12:10:36.92947	65
1716	4	2024-11-20 12:10:41.796488	38
1717	5	2024-11-20 12:10:43.446867	65
1718	7	2024-11-20 12:10:54.603566	56
1719	2	2024-11-20 12:11:08.228496	65
1720	4	2024-11-20 12:11:13.016962	38
1721	5	2024-11-20 12:11:14.663998	65
1722	7	2024-11-20 12:11:26.246346	56
1723	2	2024-11-20 12:11:39.771491	65
1724	4	2024-11-20 12:11:44.237247	38
1725	5	2024-11-20 12:11:46.319064	65
1726	7	2024-11-20 12:11:57.777114	56
1727	2	2024-11-20 12:12:10.96612	65
1728	4	2024-11-20 12:12:17.483022	38
1729	5	2024-11-20 12:12:17.671034	65
1730	7	2024-11-20 12:12:29.324401	56
1731	2	2024-11-20 12:12:43.346687	65
1732	4	2024-11-20 12:12:49.089145	38
1733	5	2024-11-20 12:12:49.309989	66
1734	7	2024-11-20 12:13:02.601731	56
1735	2	2024-11-20 12:13:14.566768	65
1736	4	2024-11-20 12:13:20.407381	38
1737	5	2024-11-20 12:13:20.599816	66
1738	7	2024-11-20 12:13:33.83469	56
1739	2	2024-11-20 12:13:45.820095	65
1740	4	2024-11-20 12:13:51.605448	38
1741	5	2024-11-20 12:13:51.824417	65
1742	7	2024-11-20 12:14:05.040005	56
1743	2	2024-11-20 12:14:17.036907	65
1744	4	2024-11-20 12:14:22.787427	38
1745	5	2024-11-20 12:14:23.09862	65
1746	7	2024-11-20 12:14:36.290776	56
1747	2	2024-11-20 12:14:48.244208	65
1748	5	2024-11-20 12:14:54.33916	65
1749	4	2024-11-20 12:14:54.545564	38
1750	7	2024-11-20 12:15:07.837566	56
1751	2	2024-11-20 12:15:19.716864	65
1752	5	2024-11-20 12:15:25.704609	65
1753	4	2024-11-20 12:15:26.069577	38
1754	7	2024-11-20 12:15:39.379373	56
1755	2	2024-11-20 12:15:53.329499	65
1756	4	2024-11-20 12:15:57.303481	38
1757	5	2024-11-20 12:15:57.615563	65
1758	7	2024-11-20 12:16:10.757256	56
1759	2	2024-11-20 12:16:24.717577	65
1760	4	2024-11-20 12:16:28.488862	38
1761	5	2024-11-20 12:16:29.135532	65
1762	7	2024-11-20 12:16:42.248187	56
1763	2	2024-11-20 12:16:55.990246	65
1764	4	2024-11-20 12:17:00.273682	37
1765	5	2024-11-20 12:17:00.422808	65
1766	7	2024-11-20 12:17:13.789511	56
1767	2	2024-11-20 12:17:27.720046	64
1768	5	2024-11-20 12:17:31.617426	65
1769	4	2024-11-20 12:17:31.812455	38
1770	7	2024-11-20 12:17:45.002283	56
1771	2	2024-11-20 12:17:59.252694	65
1772	4	2024-11-20 12:18:03.058435	38
1773	5	2024-11-20 12:18:03.356413	65
1774	7	2024-11-20 12:18:16.231703	56
1775	2	2024-11-20 12:18:30.433746	65
1776	4	2024-11-20 12:18:34.270141	38
1777	5	2024-11-20 12:18:34.610063	65
1778	7	2024-11-20 12:18:47.990556	56
1779	2	2024-11-20 12:19:01.627357	65
1780	4	2024-11-20 12:19:06.05206	38
1781	5	2024-11-20 12:19:06.240921	65
1782	7	2024-11-20 12:19:19.529354	56
1783	2	2024-11-20 12:19:33.048566	64
1784	4	2024-11-20 12:19:37.581996	38
1785	5	2024-11-20 12:19:37.670653	65
1786	7	2024-11-20 12:19:50.758799	56
1787	2	2024-11-20 12:20:04.583371	65
1788	4	2024-11-20 12:20:08.76686	38
1789	5	2024-11-20 12:20:08.934626	65
1790	7	2024-11-20 12:20:22.200675	56
1791	2	2024-11-20 12:20:35.764664	64
1792	4	2024-11-20 12:20:40.239639	38
1793	5	2024-11-20 12:20:40.463351	65
1794	7	2024-11-20 12:20:53.949003	56
1795	2	2024-11-20 12:21:07.073179	64
1796	4	2024-11-20 12:21:11.990517	38
1797	5	2024-11-20 12:21:12.240516	65
1798	7	2024-11-20 12:21:25.482838	56
1799	2	2024-11-20 12:21:38.594144	64
1800	5	2024-11-20 12:21:43.51436	65
1801	4	2024-11-20 12:21:43.717749	38
1802	7	2024-11-20 12:21:57.022294	56
1803	2	2024-11-20 12:22:10.232961	64
1804	5	2024-11-20 12:22:15.069313	65
1805	2	2024-11-20 12:22:42.701659	64
1806	5	2024-11-20 12:22:46.316799	65
1807	2	2024-11-20 12:23:14.246294	64
1808	5	2024-11-20 12:23:17.940397	65
1809	2	2024-11-20 12:23:45.775288	65
1810	5	2024-11-20 12:23:49.207987	65
1811	2	2024-11-20 12:24:17.315827	65
1812	5	2024-11-20 12:24:20.814128	65
1813	2	2024-11-20 12:24:48.875984	65
1814	5	2024-11-20 12:24:52.387633	65
1815	2	2024-11-20 12:25:20.402334	64
1816	5	2024-11-20 12:25:23.723555	65
1817	2	2024-11-20 12:25:51.732587	65
1818	5	2024-11-20 12:25:54.935233	65
1819	2	2024-11-20 12:26:23.273467	65
1820	5	2024-11-20 12:26:26.641082	65
1821	2	2024-11-20 12:26:54.448142	64
1822	5	2024-11-20 12:26:58.303471	65
1823	2	2024-11-20 12:27:25.956694	65
1824	5	2024-11-20 12:27:29.854339	65
1825	2	2024-11-20 12:27:57.687451	64
1826	5	2024-11-20 12:28:01.148706	65
1827	2	2024-11-20 12:28:29.22887	64
1828	5	2024-11-20 12:28:32.423256	65
1829	2	2024-11-20 12:29:00.779081	65
1830	5	2024-11-20 12:29:03.659048	65
1831	2	2024-11-20 12:29:32.316224	65
1832	5	2024-11-20 12:29:34.885653	65
1833	2	2024-11-20 12:30:03.496673	64
1834	5	2024-11-20 12:30:06.12858	65
1835	2	2024-11-20 12:30:34.724539	64
1836	5	2024-11-20 12:30:37.394998	65
1837	2	2024-11-20 12:31:05.929808	65
1838	5	2024-11-20 12:31:08.622899	65
1839	2	2024-11-20 12:31:37.109471	65
1840	5	2024-11-20 12:31:39.902924	65
1841	2	2024-11-20 12:32:10.727757	65
1842	5	2024-11-20 12:32:11.452432	65
1843	2	2024-11-20 12:32:41.991203	64
1844	5	2024-11-20 12:32:43.064476	65
1845	2	2024-11-20 12:33:13.193164	64
1846	5	2024-11-20 12:33:14.527499	65
1847	2	2024-11-20 12:33:44.43495	64
1848	5	2024-11-20 12:33:45.904728	65
1849	2	2024-11-20 12:34:15.956809	64
1850	5	2024-11-20 12:34:17.238539	65
1851	2	2024-11-20 12:34:47.514793	65
1852	5	2024-11-20 12:34:48.776268	65
1853	2	2024-11-20 12:35:18.691975	65
1854	5	2024-11-20 12:35:20.279749	65
1855	2	2024-11-20 12:35:49.962092	64
1856	5	2024-11-20 12:35:51.627744	65
1857	2	2024-11-20 12:36:21.505375	64
1858	5	2024-11-20 12:36:23.143539	65
1859	2	2024-11-20 12:36:52.72089	64
1860	5	2024-11-20 12:36:54.709669	65
1861	2	2024-11-20 12:37:23.975472	65
1862	5	2024-11-20 12:37:26.03937	65
1863	2	2024-11-20 12:37:55.507506	64
1864	5	2024-11-20 12:37:57.595155	65
1865	2	2024-11-20 12:38:27.08664	65
1866	5	2024-11-20 12:38:28.896562	65
1867	2	2024-11-20 12:38:58.584548	65
1868	5	2024-11-20 12:39:00.243852	65
1869	2	2024-11-20 12:39:30.121846	64
1870	5	2024-11-20 12:39:31.79155	65
1871	2	2024-11-20 12:40:01.661534	65
1872	5	2024-11-20 12:40:03.310349	65
1873	2	2024-11-20 12:40:33.217167	64
1874	5	2024-11-20 12:40:34.636613	65
1875	2	2024-11-20 12:41:04.385628	64
1876	5	2024-11-20 12:41:05.860431	65
1877	2	2024-11-20 12:41:35.874859	65
1878	5	2024-11-20 12:41:37.119228	65
1879	2	2024-11-20 12:42:07.0677	64
1880	5	2024-11-20 12:42:08.483017	65
1881	2	2024-11-20 12:42:38.340384	64
1882	2	2024-11-20 12:43:09.988314	65
1883	2	2024-11-20 12:43:41.652296	64
1884	2	2024-11-20 12:44:12.831673	64
1885	2	2024-11-20 12:44:44.185009	64
1886	2	2024-11-20 12:45:15.624702	64
1887	2	2024-11-20 12:45:47.175566	64
1888	2	2024-11-20 12:46:18.709859	64
\.


--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.section (section_id, farm_id, creation_date, section_name) FROM stdin;
1	1	2024-10-26	section 1
2	1	2024-10-26	section 2
3	1	2024-11-05	section 3
4	1	2024-11-05	section 4
5	2	2024-11-11	section 1
6	2	2024-11-11	section 2
7	11	2024-11-12	section 1
8	1	2024-11-12	section 5
\.


--
-- Data for Name: section_devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.section_devices (section_device_id, section_id, device_name, device_location, installation_date) FROM stdin;
8	5	moisture	13.014509, 77.436170	2024-11-11
11	5	valve	13.014546, 77.435773	2024-11-11
12	6	moisture	13.014985, 77.434963	2024-11-11
14	6	moisture	13.014886, 77.435349	2024-11-11
16	6	valve	13.014875, 77.434786	2024-11-11
9	5	moisture	13.014026, 77.436143	2024-11-11
10	5	moisture	13.014125, 77.435781	2024-11-11
13	6	moisture	13.014384, 77.434850	2024-11-11
15	6	moisture	13.014215, 77.435311	2024-11-11
17	7	moisture	13.023600, 77.444476	2024-11-12
18	7	moisture	13.023883, 77.444996	2024-11-12
19	7	valve	13.022765, 77.444093	2024-11-12
1	1	moisture	13.175104, 77.128706	2024-10-27
2	1	moisture	13.175063, 77.129017	2024-10-27
3	1	valve	13.175141, 77.128474	2024-10-27
4	2	moisture	13.174524, 77.128647	2024-10-27
5	2	moisture	13.174427, 77.129052	2024-10-27
6	2	valve	13.174630, 77.128280	2024-10-27
7	2	moisture	13.174530, 77.129486	2024-10-27
20	3	moisture	13.174196, 77.128483	2024-11-12
21	3	valve	13.174289, 77.128146	2024-11-12
22	4	moisture	13.173675, 77.128843	2024-11-12
23	4	valve	13.173781, 77.128324	2024-11-12
24	8	moisture	13.174025, 77.129280	2024-11-12
25	8	valve	13.173602, 77.129184	2024-11-12
\.


--
-- Data for Name: valve_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.valve_data (valve_data_id, section_device_id, valve_mode, valve_status, "timestamp", manual_off_timer) FROM stdin;
66	6	manual	on	2024-11-20 05:00:00.270131	555
1	3	manual	on	2024-10-27 18:24:17.661751	10
67	6	manual	off	2024-11-20 05:00:06.413065	549
68	21	manual	off	2024-11-20 05:09:41.687808	1
6	3	manual	on	2024-11-05 11:17:14.609867	10
69	3	manual	off	2024-11-20 05:09:41.687808	1
3	3	auto	on	2024-11-05 08:36:27.077754	0
4	3	auto	on	2024-11-05 11:12:44.842199	0
5	3	auto	on	2024-11-05 11:13:28.122312	0
7	3	auto	on	2024-11-05 11:26:41.44286	0
8	3	auto	on	2024-11-05 11:28:49.940761	0
70	25	manual	off	2024-11-20 05:09:41.687808	1
11	11	auto	off	2024-11-08 09:38:28.809063	0
12	16	manual	on	2024-11-08 09:46:12.241846	0
71	23	manual	off	2024-11-20 05:09:41.687808	1
10	19	auto	on	2024-11-12 04:52:01.831753	0
14	23	manual	off	2024-11-12 06:22:02.074126	0
72	6	auto	off	2024-11-20 05:11:46.501058	0
73	6	auto	off	2024-11-20 05:12:28.9044	0
74	6	manual	on	2024-11-20 05:12:45.698675	285
75	6	manual	off	2024-11-20 05:12:58.802647	273
9	3	auto	on	2024-11-05 11:32:01.711337	0
18	3	auto	on	2024-11-18 15:46:45.894525	0
76	25	manual	on	2024-11-20 05:13:14.995202	285
17	3	auto	off\n	2024-11-18 15:44:13.219672	0
19	3	auto	on	2024-11-18 22:06:36.586336	0
20	3	auto	on	2024-11-18 22:26:08.650015	0
21	3	auto	on	2024-11-18 22:26:21.386671	0
22	3	auto	on	2024-11-18 22:36:44.436178	0
23	3	auto	on	2024-11-18 22:44:34.037759	0
77	25	manual	off	2024-11-20 05:13:19.084371	281
78	3	manual	on	2024-11-20 05:16:27.095538	1
13	21	manual	off	2024-11-12 06:22:02.074126	0
15	23	manual	off	2024-11-12 06:42:37.885268	0
79	3	manual	off	2024-11-20 05:16:41.393646	0
80	3	manual	on	2024-11-20 05:16:55.151884	500
24	3	manual	on	2024-11-19 14:25:22.594612	1
2	6	manual	on	2024-10-27 18:24:17.961751	1
26	6	manual	off	2024-11-19 15:25:54.421605	0
25	3	auto	off	2024-11-19 15:21:52.554415	0
81	3	manual	off	2024-11-20 05:21:20.567747	0
27	3	manual	on	2024-11-19 16:26:26.343398	4
82	3	manual	off	2024-11-20 05:21:22.220686	0
83	3	manual	off	2024-11-20 05:21:23.640041	0
28	3	auto	on	2024-11-19 16:43:28.228708	0
29	3	manual	on	2024-11-19 16:58:32.926463	1
16	25	manual	on	2024-11-12 06:42:37.985268	1
84	3	auto	off	2024-11-20 05:21:26.506617	0
85	3	manual	on	2024-11-20 05:22:04.190132	500
30	25	auto	off	2024-11-19 17:08:35.33645	10
86	3	manual	off	2024-11-20 05:22:21.190591	0
31	25	auto	off	2024-11-19 17:11:35.877282	0
87	21	auto	off	2024-11-20 05:27:15.077936	0
32	25	auto	off	2024-11-19 17:21:09.138108	0
33	25	manual	off	2024-11-19 17:25:09.592286	0
34	19	auto	off	2024-11-19 14:09:07.618442	0
35	21	auto	on	2024-11-19 16:07:53.179273	0
36	23	auto	on	2024-11-19 16:07:53.179273	0
37	6	auto	on	2024-11-19 16:07:53.179273	0
38	3	auto	off	2024-11-19 16:07:53.179273	0
39	25	auto	off	2024-11-19 16:07:53.179273	0
40	21	manual	on	2024-11-19 16:19:25.899323	11
41	23	manual	on	2024-11-19 16:19:25.899323	11
42	6	manual	on	2024-11-19 16:19:25.899323	11
43	3	manual	on	2024-11-19 16:19:25.899323	11
44	25	manual	off	2024-11-19 16:19:25.899323	11
45	25	manual	on	2024-11-19 16:57:19.308476	11
88	3	auto	off	2024-11-20 05:27:32.907674	0
46	3	manual	on	2024-11-20 03:44:56.134164	1
47	3	manual	off	2024-11-20 10:03:07.537152	0
48	21	auto	on	2024-11-20 04:42:40.851299	1
49	23	auto	on	2024-11-20 04:42:40.851299	1
50	6	auto	off	2024-11-20 04:42:40.851299	1
51	25	auto	off	2024-11-20 04:42:40.851299	1
52	3	auto	off	2024-11-20 04:42:40.851299	1
53	21	manual	on	2024-11-20 04:43:24.48539	1
54	23	manual	on	2024-11-20 04:43:24.48539	1
55	6	manual	on	2024-11-20 04:43:24.48539	1
56	25	manual	on	2024-11-20 04:43:24.48539	1
57	3	manual	on	2024-11-20 04:43:24.48539	1
58	21	manual	on	2024-11-20 04:45:40.901793	55
59	6	manual	off	2024-11-20 10:16:13.972549	0
60	3	manual	off	2024-11-20 10:16:14.189692	0
61	3	manual	on	2024-11-20 04:47:34.429792	55
62	25	manual	on	2024-11-20 04:49:34.844894	88
63	23	manual	on	2024-11-20 04:58:00.463922	5
64	6	manual	on	2024-11-20 04:59:23.617425	555
65	6	manual	off	2024-11-20 04:59:47.366374	531
89	23	manual	on	2024-11-20 05:31:54.426971	55
90	23	manual	on	2024-11-20 05:31:55.24681	55
91	23	manual	on	2024-11-20 05:32:27.810455	77
92	3	manual	on	2024-11-20 05:32:51.772173	55
93	23	manual	off	2024-11-20 05:34:28.856072	0
94	3	manual	off	2024-11-20 05:34:31.405848	0
95	21	auto	off	2024-11-20 05:37:57.74891	0
96	21	manual	on	2024-11-20 05:38:33.793314	2
97	21	manual	off	2024-11-20 05:38:35.641765	0
98	25	auto	off	2024-11-20 05:39:07.689348	0
99	6	auto	off	2024-11-20 05:46:56.381688	0
100	6	auto	on	2024-11-20 11:16:59.751077	0
101	6	auto	off	2024-11-20 11:19:08.870335	0
102	6	auto	on	2024-11-20 11:20:05.595867	0
103	3	manual	on	2024-11-20 05:59:57.19732	55
104	3	manual	off	2024-11-20 06:00:05.698322	48
105	3	manual	on	2024-11-20 06:00:14.09311	55
106	3	manual	off	2024-11-20 06:00:20.646953	49
107	3	manual	on	2024-11-20 06:00:59.366717	60
108	3	manual	off	2024-11-20 06:02:40.324797	0
109	3	manual	on	2024-11-20 06:04:00.197022	1
110	3	manual	off	2024-11-20 11:35:00.787499	0
111	3	manual	off	2024-11-20 06:05:07.171605	0
112	3	manual	on	2024-11-20 06:07:51.010996	1
113	3	manual	off	2024-11-20 11:38:51.633773	0
114	16	manual	off	2024-11-20 06:09:15.802115	0
115	3	manual	on	2024-11-20 06:20:00.275458	1
116	3	manual	off	2024-11-20 06:20:07.89723	0
117	6	auto	off	2024-11-20 11:56:35.548039	0
118	6	auto	on	2024-11-20 11:57:11.72352	0
119	3	manual	on	2024-11-20 06:27:34.983633	1
120	3	manual	off	2024-11-20 06:28:03.04162	0
121	6	auto	off	2024-11-20 12:00:16.524044	0
122	3	manual	on	2024-11-20 06:33:02.890922	1
123	3	manual	off	2024-11-20 06:33:11.01214	0
124	3	auto	off	2024-11-20 08:22:19.028697	0
125	23	manual	on	2024-11-20 09:06:41.400404	1
126	23	manual	off	2024-11-20 09:07:13.786042	0
127	25	auto	off	2024-11-20 09:07:26.278021	0
128	23	manual	on	2024-11-20 09:07:53.926671	5
129	23	manual	off	2024-11-20 09:08:24.030798	0
130	6	manual	on	2024-11-20 09:20:48.489125	1
131	25	auto	off	2024-11-20 09:21:00.981988	1
132	6	manual	off	2024-11-20 09:27:34.774989	0
133	23	auto	off	2024-11-20 09:35:07.460986	0
\.


--
-- Name: admin_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_admin_id_seq', 101, true);


--
-- Name: devices_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.devices_device_id_seq', 25, true);


--
-- Name: farm_devices_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farm_devices_device_id_seq', 4, true);


--
-- Name: farm_farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farm_farm_id_seq', 11, true);


--
-- Name: farm_log_farm_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farm_log_farm_log_id_seq', 1, false);


--
-- Name: farmer_farmer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farmer_farmer_id_seq', 1005, true);


--
-- Name: field_data_field_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.field_data_field_data_id_seq', 21, true);


--
-- Name: moisture_data_moisture_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moisture_data_moisture_data_id_seq', 1888, true);


--
-- Name: section_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.section_section_id_seq', 8, true);


--
-- Name: valve_data_valve_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.valve_data_valve_data_id_seq', 133, true);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (admin_id);


--
-- Name: section_devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section_devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (section_device_id);


--
-- Name: farm_devices farm_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm_devices
    ADD CONSTRAINT farm_devices_pkey PRIMARY KEY (farm_device_id);


--
-- Name: farm_log farm_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm_log
    ADD CONSTRAINT farm_log_pkey PRIMARY KEY (farm_log_id, description);


--
-- Name: farm farm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (farm_id);


--
-- Name: farmer farmer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer
    ADD CONSTRAINT farmer_pkey PRIMARY KEY (farmer_id);


--
-- Name: field_data field_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field_data
    ADD CONSTRAINT field_data_pkey PRIMARY KEY (field_data_id);


--
-- Name: moisture_data moisture_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moisture_data
    ADD CONSTRAINT moisture_data_pkey PRIMARY KEY (moisture_data_id);


--
-- Name: section section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_pkey PRIMARY KEY (section_id);


--
-- Name: admin unique_admin_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT unique_admin_email UNIQUE (admin_email);


--
-- Name: farmer unique_farmer_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer
    ADD CONSTRAINT unique_farmer_email UNIQUE (farmer_email);


--
-- Name: valve_data valve_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.valve_data
    ADD CONSTRAINT valve_data_pkey PRIMARY KEY (valve_data_id);


--
-- Name: farm_devices devices_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm_devices
    ADD CONSTRAINT devices_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farm(farm_id) ON DELETE CASCADE;


--
-- Name: section_devices devices_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section_devices
    ADD CONSTRAINT devices_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.section(section_id) ON DELETE CASCADE;


--
-- Name: field_data farm_device_farm_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field_data
    ADD CONSTRAINT farm_device_farm_id FOREIGN KEY (farm_device_id) REFERENCES public.farm_devices(farm_device_id) ON DELETE CASCADE NOT VALID;


--
-- Name: farm farm_farmer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm
    ADD CONSTRAINT farm_farmer_id_fkey FOREIGN KEY (farmer_id) REFERENCES public.farmer(farmer_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: farm_log farm_log_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm_log
    ADD CONSTRAINT farm_log_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farm(farm_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: farmer farmer_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer
    ADD CONSTRAINT farmer_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id);


--
-- Name: farmer fk_admin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer
    ADD CONSTRAINT fk_admin FOREIGN KEY (admin_id) REFERENCES public.admin(admin_id) ON DELETE SET NULL;


--
-- Name: moisture_data moisture_data_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moisture_data
    ADD CONSTRAINT moisture_data_device_id_fkey FOREIGN KEY (section_device_id) REFERENCES public.section_devices(section_device_id) ON DELETE CASCADE;


--
-- Name: section section_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farm(farm_id) ON DELETE CASCADE;


--
-- Name: valve_data valve_data_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.valve_data
    ADD CONSTRAINT valve_data_device_id_fkey FOREIGN KEY (section_device_id) REFERENCES public.section_devices(section_device_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

