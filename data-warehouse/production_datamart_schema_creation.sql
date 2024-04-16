BEGIN;


CREATE TABLE IF NOT EXISTS public.dim_date
(
    date_tk integer NOT NULL,
    the_date timestamp without time zone,
    the_year integer,
    the_quarter integer,
    the_month integer,
    the_week integer,
    day_of_year integer,
    day_of_month integer,
    day_of_week integer,
    CONSTRAINT dim_date_pkey PRIMARY KEY (date_tk)
);

CREATE TABLE IF NOT EXISTS public.dim_employee
(
    employee_id integer,
    employee_full_name text COLLATE pg_catalog."default",
    department_id integer,
    department_name text COLLATE pg_catalog."default",
    employee_tk integer NOT NULL,
    version integer,
    date_from timestamp without time zone,
    date_to timestamp without time zone,
    CONSTRAINT dim_employee_pkey PRIMARY KEY (employee_tk)
);

CREATE TABLE IF NOT EXISTS public.dim_machines
(
    machine_id integer,
    state text COLLATE pg_catalog."default",
    cost_per_hour double precision,
    machine_type text COLLATE pg_catalog."default",
    tk_machine_id bigserial NOT NULL,
    version integer,
    date_from timestamp without time zone,
    date_to timestamp without time zone,
    CONSTRAINT dim_machines_pkey PRIMARY KEY (tk_machine_id)
);

CREATE TABLE IF NOT EXISTS public.fact_production_orders
(
    production_order_id integer NOT NULL,
    tk_machine_id integer,
    tk_date integer,
    employee_tk integer,
    machine_hours double precision,
    employee_hours double precision,
    quantity_produced integer,
    cycle_time double precision,
    CONSTRAINT fact_production_orders_pkey PRIMARY KEY (production_order_id)
);

ALTER TABLE IF EXISTS public.fact_production_orders
    ADD CONSTRAINT factproductionorders_fk1 FOREIGN KEY (tk_date)
    REFERENCES public.dim_date (date_tk) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.fact_production_orders
    ADD CONSTRAINT factproductionorders_fk2 FOREIGN KEY (employee_tk)
    REFERENCES public.dim_employee (employee_tk) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.fact_production_orders
    ADD CONSTRAINT factproductionorders_fk3 FOREIGN KEY (tk_machine_id)
    REFERENCES public.dim_machines (tk_machine_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

END;