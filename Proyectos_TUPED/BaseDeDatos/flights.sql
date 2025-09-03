-- DDL creacion de tablas 

CREATE TABLE IF NOT EXISTS bookings
(
    book_ref character(6) COLLATE pg_catalog."default" NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    CONSTRAINT bookings_pkey PRIMARY KEY (book_ref)
);


CREATE TABLE IF NOT EXISTS tickets
(
    ticket_no character(13) COLLATE pg_catalog."default" NOT NULL,
    book_ref character(6) COLLATE pg_catalog."default" NOT NULL,
    passenger_id character varying(20) COLLATE pg_catalog."default" NOT NULL,
    passenger_name text COLLATE pg_catalog."default" NOT NULL,
    contact_data jsonb,
    CONSTRAINT tickets_pkey PRIMARY KEY (ticket_no),
    CONSTRAINT tickets_book_ref_fkey FOREIGN KEY (book_ref)
        REFERENCES bookings.bookings (book_ref) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS bookings.flights
(
    flight_id integer NOT NULL DEFAULT nextval('bookings.flights_flight_id_seq'::regclass),
    flight_no character(6) COLLATE pg_catalog."default" NOT NULL,
    scheduled_departure timestamp with time zone NOT NULL,
    scheduled_arrival timestamp with time zone NOT NULL,
    departure_airport character(3) COLLATE pg_catalog."default" NOT NULL,
    arrival_airport character(3) COLLATE pg_catalog."default" NOT NULL,
    status character varying(20) COLLATE pg_catalog."default" NOT NULL,
    aircraft_code character(3) COLLATE pg_catalog."default" NOT NULL,
    actual_departure timestamp with time zone,
    actual_arrival timestamp with time zone,
    CONSTRAINT flights_pkey PRIMARY KEY (flight_id),
    CONSTRAINT flights_flight_no_scheduled_departure_key UNIQUE (flight_no, scheduled_departure),
    CONSTRAINT flights_aircraft_code_fkey FOREIGN KEY (aircraft_code)
        REFERENCES bookings.aircrafts_data (aircraft_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT flights_arrival_airport_fkey FOREIGN KEY (arrival_airport)
        REFERENCES bookings.airports_data (airport_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT flights_departure_airport_fkey FOREIGN KEY (departure_airport)
        REFERENCES bookings.airports_data (airport_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT flights_check CHECK (scheduled_arrival > scheduled_departure),
    CONSTRAINT flights_check1 CHECK (actual_arrival IS NULL OR actual_departure IS NOT NULL AND actual_arrival IS NOT NULL AND actual_arrival > actual_departure),
    CONSTRAINT flights_status_check CHECK (status::text = ANY (ARRAY['On Time'::character varying::text, 'Delayed'::character varying::text, 'Departed'::character varying::text, 'Arrived'::character varying::text, 'Scheduled'::character varying::text, 'Cancelled'::character varying::text]))
);

CREATE TABLE IF NOT EXISTS airports_data
(
    airport_code character(3) COLLATE pg_catalog."default" NOT NULL,
    airport_name jsonb NOT NULL,
    city jsonb NOT NULL,
    coordinates point NOT NULL,
    timezone text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT airports_data_pkey PRIMARY KEY (airport_code)
);

CREATE TABLE IF NOT EXISTS aircrafts_data
(
    aircraft_code character(3) COLLATE pg_catalog."default" NOT NULL,
    model jsonb NOT NULL,
    range integer NOT NULL,
    CONSTRAINT aircrafts_pkey PRIMARY KEY (aircraft_code),
    CONSTRAINT aircrafts_range_check CHECK (range > 0)
); 

CREATE TABLE IF NOT EXISTS boarding_passes
(
    ticket_no character(13) COLLATE pg_catalog."default" NOT NULL,
    flight_id integer NOT NULL,
    boarding_no integer NOT NULL,
    seat_no character varying(4) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT boarding_passes_pkey PRIMARY KEY (ticket_no, flight_id),
    CONSTRAINT boarding_passes_flight_id_boarding_no_key UNIQUE (flight_id, boarding_no),
    CONSTRAINT boarding_passes_flight_id_seat_no_key UNIQUE (flight_id, seat_no),
    CONSTRAINT boarding_passes_ticket_no_fkey FOREIGN KEY (flight_id, ticket_no)
        REFERENCES bookings.ticket_flights (flight_id, ticket_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);



CREATE TABLE IF NOT EXISTS seats
(
    aircraft_code character(3) COLLATE pg_catalog."default" NOT NULL,
    seat_no character varying(4) COLLATE pg_catalog."default" NOT NULL,
    fare_conditions character varying(10) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT seats_pkey PRIMARY KEY (aircraft_code, seat_no),
    CONSTRAINT seats_aircraft_code_fkey FOREIGN KEY (aircraft_code)
        REFERENCES bookings.aircrafts_data (aircraft_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT seats_fare_conditions_check CHECK (fare_conditions::text = ANY (ARRAY['Economy'::character varying::text, 'Comfort'::character varying::text, 'Business'::character varying::text]))
);


CREATE TABLE IF NOT EXISTS bookings.ticket_flights
(
    ticket_no character(13) COLLATE pg_catalog."default" NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions character varying(10) COLLATE pg_catalog."default" NOT NULL,
    amount numeric(10,2) NOT NULL,
    CONSTRAINT ticket_flights_pkey PRIMARY KEY (ticket_no, flight_id),
    CONSTRAINT ticket_flights_flight_id_fkey FOREIGN KEY (flight_id)
        REFERENCES bookings.flights (flight_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT ticket_flights_ticket_no_fkey FOREIGN KEY (ticket_no)
        REFERENCES bookings.tickets (ticket_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT ticket_flights_amount_check CHECK (amount >= 0::numeric),
    CONSTRAINT ticket_flights_fare_conditions_check CHECK (fare_conditions::text = ANY (ARRAY['Economy'::character varying::text, 'Comfort'::character varying::text, 'Business'::character varying::text]))
); 


-- CONSULTAS 

-- 1) Identificador de vuelo en el que hayan abordado entre 100 y 120 personas

SELECT f.flight_id, COUNT (DISTINCT bp.boarding_no) as cantidad_pasajeros
FROM bookings.flights f 
JOIN bookings.boarding_passes bp ON f.flight_id = bp.flight_id
GROUP BY f.flight_id
HAVING COUNT (DISTINCT bp.boarding_no) BETWEEN 100 AND 120 ;


--2) MOSTRAR SOLO LOS NOMBRES DE LOS PASAJEROS QUE TOMARON MAS DE 10 VUELOS EN ESE MES
SELECT passenger_name
FROM bookings.flights f
JOIN bookings.boarding_passes bp ON f.flight_id = bp.flight_id
JOIN bookings.tickets t ON bp.ticket_no = t.ticket_no
GROUP BY passenger_name
HAVING COUNT(*) > 10;



-- 3) a) Mostrar los tickets vendidos y los tickets que abordaron el vuelo 

SELECT
    (SELECT COUNT(*) FROM bookings.tickets) AS num_tickets_vendidos,
    COUNT(DISTINCT t.ticket_no) AS num_tickets_abordados
FROM bookings.tickets t
JOIN bookings.boarding_passes bp ON t.ticket_no = bp.ticket_no;

-- 3) b) LOS TICKETS QUE SE COMPRARON PERO NO ABORDARON EL VUELO	
--esta forma de consultar es mejor ya que no cuenta dos veces y hace operacion de conjunto 
SELECT count(DISTINCT t.ticket_no) AS no_abordaron
FROM bookings.tickets t
LEFT JOIN bookings.boarding_passes bp ON t.ticket_no = bp.ticket_no
WHERE bp.ticket_no IS NULL;



-- 4) NOMBRES DE LOS PASAJEROS Q ABORDARON ENTRE DOS FECHAS EN EL AEOROPUERTO DME 

SELECT t.passenger_name
FROM bookings.flights f
JOIN bookings.boarding_passes bp ON f.flight_id = bp.flight_id
JOIN bookings.tickets t ON bp.ticket_no = t.ticket_no
WHERE f.actual_departure BETWEEN '2017-07-16 03:44:00-03' AND '2017-07-17 09:40:00-03' 
AND f.departure_airport = 'DME'
LIMIT 100;

-- consulta n° 4 optimizada
SELECT SC4.passenger_name
FROM (SELECT passenger_name, ticket_no FROM bookings.tickets t ) SC4,
	(SELECT SC2.ticket_no
	FROM (SELECT flight_id FROM bookings.flights f WHERE f.actual_departure 
		  BETWEEN '2017-07-16 03:44:00-03' AND '2017-07-17 09:40:00-03' AND f.departure_airport = 'DME') SC1,
	 		(SELECT flight_id, ticket_no FROM bookings.boarding_passes) SC2
	  WHERE SC1.flight_id = SC2.flight_id) SC3 
WHERE SC4.ticket_no = SC3.ticket_no







SELECT passenger_name, SC2.ticket_no
FROM (SELECT passenger_name, flight_id, 
						 FROM bookings.flights 
						 
	


