--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

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

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'user',
    'moderator',
    'dokter'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: body_weight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.body_weight (
    id integer NOT NULL,
    cow_id character varying(50),
    date date NOT NULL,
    weight numeric NOT NULL
);


ALTER TABLE public.body_weight OWNER TO postgres;

--
-- Name: body_weight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.body_weight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.body_weight_id_seq OWNER TO postgres;

--
-- Name: body_weight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.body_weight_id_seq OWNED BY public.body_weight.id;


--
-- Name: cows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cows (
    id integer NOT NULL,
    cow_id character varying(50) NOT NULL,
    gender character varying(10),
    age integer,
    health_record jsonb,
    stress_level integer,
    birahi character varying(50),
    status character varying(50),
    note text,
    iskandang boolean DEFAULT true,
    nfc_id character(255)
);


ALTER TABLE public.cows OWNER TO postgres;

--
-- Name: COLUMN cows.nfc_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cows.nfc_id IS 'NFC TAG ID';


--
-- Name: cows_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cows_id_seq OWNER TO postgres;

--
-- Name: cows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cows_id_seq OWNED BY public.cows.id;


--
-- Name: feed_hijauan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed_hijauan (
    id integer NOT NULL,
    cow_id character varying(50),
    date date NOT NULL,
    amount numeric NOT NULL
);


ALTER TABLE public.feed_hijauan OWNER TO postgres;

--
-- Name: feed_hijauan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_hijauan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_hijauan_id_seq OWNER TO postgres;

--
-- Name: feed_hijauan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_hijauan_id_seq OWNED BY public.feed_hijauan.id;


--
-- Name: feed_sentrate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feed_sentrate (
    id integer NOT NULL,
    cow_id character varying(50),
    date date NOT NULL,
    amount numeric NOT NULL
);


ALTER TABLE public.feed_sentrate OWNER TO postgres;

--
-- Name: feed_sentrate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feed_sentrate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feed_sentrate_id_seq OWNER TO postgres;

--
-- Name: feed_sentrate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feed_sentrate_id_seq OWNED BY public.feed_sentrate.id;


--
-- Name: milk_production; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.milk_production (
    id integer NOT NULL,
    cow_id character varying(50),
    date date NOT NULL,
    production_amount numeric NOT NULL
);


ALTER TABLE public.milk_production OWNER TO postgres;

--
-- Name: milk_production_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.milk_production_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.milk_production_id_seq OWNER TO postgres;

--
-- Name: milk_production_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.milk_production_id_seq OWNED BY public.milk_production.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    phone character varying(20),
    cage_location text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: body_weight id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.body_weight ALTER COLUMN id SET DEFAULT nextval('public.body_weight_id_seq'::regclass);


--
-- Name: cows id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cows ALTER COLUMN id SET DEFAULT nextval('public.cows_id_seq'::regclass);


--
-- Name: feed_hijauan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_hijauan ALTER COLUMN id SET DEFAULT nextval('public.feed_hijauan_id_seq'::regclass);


--
-- Name: feed_sentrate id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_sentrate ALTER COLUMN id SET DEFAULT nextval('public.feed_sentrate_id_seq'::regclass);


--
-- Name: milk_production id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milk_production ALTER COLUMN id SET DEFAULT nextval('public.milk_production_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: body_weight; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.body_weight (id, cow_id, date, weight) FROM stdin;
4	1	2023-10-01	500
7	4	2024-11-11	200
8	3	2023-11-10	510
12	3	2023-11-11	510
13	5	2024-11-11	12
32	1	2023-10-02	500
33	4	2023-10-02	200
34	3	2023-10-03	510
35	2	2023-10-04	510
36	5	2023-10-05	400
37	2	2023-10-06	420
38	3	2023-10-07	430
39	4	2023-10-08	440
40	5	2023-10-09	450
41	1	2023-10-10	460
42	1	2023-10-11	470
43	4	2023-10-12	210
44	3	2023-10-13	520
45	2	2023-10-14	530
46	5	2023-10-15	410
47	1	2023-10-16	480
48	4	2023-10-17	220
49	3	2023-10-18	530
50	2	2023-10-19	540
51	5	2023-10-20	420
52	1	2023-10-21	490
53	4	2023-10-22	230
54	3	2023-10-23	540
55	2	2023-10-24	550
56	5	2023-10-25	430
57	1	2023-10-26	500
58	4	2023-10-27	240
59	3	2023-10-28	550
60	2	2023-10-29	560
61	5	2023-10-30	440
62	100	2024-11-22	12
\.


--
-- Data for Name: cows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cows (id, cow_id, gender, age, health_record, stress_level, birahi, status, note, iskandang, nfc_id) FROM stdin;
14	5	Betina	21	true	\N	\N	\N	\N	t	\N
21	100	Betina	12	true	\N	\N	\N	\N	t	\N
7	1	Jantan	12	true	\N	\N	\N	\N	t	3a:ad:ef:b0                                                                                                                                                                                                                                                    
8	2	Betina	20	true	\N	\N	\N	\N	t	3a:ad:ef:b0                                                                                                                                                                                                                                                    
9	3	Jantan	213	false	\N	\N	\N	\N	t	3a:ad:ef:b0                                                                                                                                                                                                                                                    
13	4	Betina	23	false	\N	\N	\N	\N	t	3a:ad:ef:b0                                                                                                                                                                                                                                                    
\.


--
-- Data for Name: feed_hijauan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_hijauan (id, cow_id, date, amount) FROM stdin;
4	1	2023-10-01	25
6	1	2023-10-02	30
7	1	2023-10-03	28
8	1	2023-10-04	32
9	1	2023-10-05	27
10	1	2023-10-06	29
11	1	2023-10-07	31
12	1	2023-10-08	26
13	1	2023-10-09	34
14	1	2023-10-10	33
15	1	2023-10-11	30
16	2	2023-10-02	35
17	2	2023-10-03	33
18	2	2023-10-04	36
19	2	2023-10-05	32
20	2	2023-10-06	34
21	2	2023-10-07	30
22	2	2023-10-08	31
23	2	2023-10-09	33
24	2	2023-10-10	28
25	2	2023-10-11	29
\.


--
-- Data for Name: feed_sentrate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feed_sentrate (id, cow_id, date, amount) FROM stdin;
4	1	2023-10-01	15
6	1	2023-10-02	15
7	1	2023-10-03	14
8	1	2023-10-04	16
9	1	2023-10-05	13
10	1	2023-10-06	12
11	1	2023-10-07	14
12	1	2023-10-08	13
13	1	2023-10-09	15
14	1	2023-10-10	16
15	1	2023-10-11	12
16	2	2023-10-02	17
17	2	2023-10-03	16
18	2	2023-10-04	18
19	2	2023-10-05	15
20	2	2023-10-06	14
21	2	2023-10-07	16
22	2	2023-10-08	15
23	2	2023-10-09	17
24	2	2023-10-10	14
25	2	2023-10-11	13
\.


--
-- Data for Name: milk_production; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.milk_production (id, cow_id, date, production_amount) FROM stdin;
4	1	2023-10-01	70
6	1	2023-10-02	72
7	1	2023-10-03	68
8	1	2023-10-04	75
9	1	2023-10-05	70
10	1	2023-10-06	74
11	1	2023-10-07	71
12	1	2023-10-08	69
13	1	2023-10-09	73
14	1	2023-10-10	76
15	1	2023-10-11	65
16	1	2023-10-12	78
17	1	2023-10-13	67
18	1	2023-10-14	72
19	1	2023-10-15	74
20	1	2023-10-16	71
21	1	2023-10-17	69
22	1	2023-10-18	76
23	1	2023-10-19	68
24	1	2023-10-20	70
25	2	2023-10-02	80
26	2	2023-10-03	78
27	2	2023-10-04	82
28	2	2023-10-05	79
29	2	2023-10-06	77
30	2	2023-10-07	85
31	2	2023-10-08	80
32	2	2023-10-09	83
33	2	2023-10-10	81
34	2	2023-10-11	82
35	2	2023-10-12	79
36	2	2023-10-13	84
37	2	2023-10-14	76
38	2	2023-10-15	81
39	2	2023-10-16	82
40	2	2023-10-17	78
41	2	2023-10-18	85
42	2	2023-10-19	80
43	2	2023-10-20	83
44	1	2024-11-16	10
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email, role, created_at, updated_at, phone, cage_location) FROM stdin;
7	user	$2b$10$T1e8DtZrFMmk2/727TWr3OcmspJpRKxG70K52ZfKY2NAaASPLBYI6	john.doe@example.com	user	2024-11-30 09:08:49.996382	2024-11-30 09:08:49.996382	081232	Lamongan
8	admin	$2b$10$7PnApq3D6NdVdxZFCStzUuYGyejXdPjAn1NDRfhbdLNzeHpMKVRHi	john.doe@example.com	admin	2024-11-30 09:13:34.487651	2024-11-30 09:13:34.487651	081232	Lamongan
9	dokter	$2b$10$PA/wZqgzfrMkBZtKD6lCKO3JQ2gbizM322BiNQo//lRc7Lp/YMnhC	john.doe@example.com	dokter	2024-11-30 09:16:01.729944	2024-11-30 09:16:01.729944	081232	Lamongan
\.


--
-- Name: body_weight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.body_weight_id_seq', 62, true);


--
-- Name: cows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cows_id_seq', 21, true);


--
-- Name: feed_hijauan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_hijauan_id_seq', 25, true);


--
-- Name: feed_sentrate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feed_sentrate_id_seq', 25, true);


--
-- Name: milk_production_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.milk_production_id_seq', 44, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 9, true);


--
-- Name: body_weight body_weight_cow_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.body_weight
    ADD CONSTRAINT body_weight_cow_id_date_key UNIQUE (cow_id, date);


--
-- Name: body_weight body_weight_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.body_weight
    ADD CONSTRAINT body_weight_pkey PRIMARY KEY (id);


--
-- Name: cows cows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cows
    ADD CONSTRAINT cows_pkey PRIMARY KEY (id);


--
-- Name: feed_hijauan feed_hijauan_cow_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_hijauan
    ADD CONSTRAINT feed_hijauan_cow_id_date_key UNIQUE (cow_id, date);


--
-- Name: feed_hijauan feed_hijauan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_hijauan
    ADD CONSTRAINT feed_hijauan_pkey PRIMARY KEY (id);


--
-- Name: feed_sentrate feed_sentrate_cow_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_sentrate
    ADD CONSTRAINT feed_sentrate_cow_id_date_key UNIQUE (cow_id, date);


--
-- Name: feed_sentrate feed_sentrate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_sentrate
    ADD CONSTRAINT feed_sentrate_pkey PRIMARY KEY (id);


--
-- Name: milk_production milk_production_cow_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milk_production
    ADD CONSTRAINT milk_production_cow_id_date_key UNIQUE (cow_id, date);


--
-- Name: milk_production milk_production_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milk_production
    ADD CONSTRAINT milk_production_pkey PRIMARY KEY (id);


--
-- Name: cows unique_cow_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cows
    ADD CONSTRAINT unique_cow_id UNIQUE (cow_id);


--
-- Name: users unique_username; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_username UNIQUE (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: body_weight body_weight_cow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.body_weight
    ADD CONSTRAINT body_weight_cow_id_fkey FOREIGN KEY (cow_id) REFERENCES public.cows(cow_id) ON DELETE CASCADE;


--
-- Name: feed_hijauan feed_hijauan_cow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_hijauan
    ADD CONSTRAINT feed_hijauan_cow_id_fkey FOREIGN KEY (cow_id) REFERENCES public.cows(cow_id) ON DELETE CASCADE;


--
-- Name: feed_sentrate feed_sentrate_cow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feed_sentrate
    ADD CONSTRAINT feed_sentrate_cow_id_fkey FOREIGN KEY (cow_id) REFERENCES public.cows(cow_id) ON DELETE CASCADE;


--
-- Name: milk_production milk_production_cow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milk_production
    ADD CONSTRAINT milk_production_cow_id_fkey FOREIGN KEY (cow_id) REFERENCES public.cows(cow_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

