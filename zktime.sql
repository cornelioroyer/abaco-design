--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ac_group; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE ac_group (
    id integer NOT NULL,
    acgroup_id integer NOT NULL,
    acgroup_name character varying(64),
    acgroup_holidayvalid boolean,
    acgroup_verifystytle integer,
    timezone1 integer,
    timezone2 integer,
    timezone3 integer,
    terminal_id integer NOT NULL
);


ALTER TABLE public.ac_group OWNER TO dba;

--
-- Name: ac_holidaysetting; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE ac_holidaysetting (
    holiday_id integer NOT NULL,
    holiday_name character varying(64),
    holiday_start timestamp without time zone,
    holiday_end timestamp without time zone,
    actimezoneid integer
);


ALTER TABLE public.ac_holidaysetting OWNER TO dba;

--
-- Name: ac_timezone; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE ac_timezone (
    timezone_id integer NOT NULL,
    timezone_name character varying(64),
    timezone_sunstart timestamp without time zone,
    timezone_sunend timestamp without time zone,
    timezone_monstart timestamp without time zone,
    timezone_monend timestamp without time zone,
    timezone_tuesstart timestamp without time zone,
    timezone_tuesend timestamp without time zone,
    timezone_wedstart timestamp without time zone,
    timezone_wedend timestamp without time zone,
    timezone_thursstart timestamp without time zone,
    timezone_thursend timestamp without time zone,
    timezone_fristart timestamp without time zone,
    timezone_friend timestamp without time zone,
    timezone_satstart timestamp without time zone,
    timezone_satend timestamp without time zone
);


ALTER TABLE public.ac_timezone OWNER TO dba;

--
-- Name: ac_unlockcomb; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE ac_unlockcomb (
    id integer NOT NULL,
    unlockcomb_id integer NOT NULL,
    unlockcomb_name character varying(64),
    acgroup1 integer,
    acgroup2 integer,
    acgroup3 integer,
    acgroup4 integer,
    acgroup5 integer,
    terminal_id integer NOT NULL
);


ALTER TABLE public.ac_unlockcomb OWNER TO dba;

--
-- Name: ac_userprivilege; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE ac_userprivilege (
    id integer NOT NULL,
    isusergroup boolean,
    verifystytle integer,
    disable boolean,
    employee_id integer NOT NULL,
    terminal_id integer NOT NULL,
    timezone1 integer,
    timezone2 integer,
    timezone3 integer,
    acgroup_id integer
);


ALTER TABLE public.ac_userprivilege OWNER TO dba;

--
-- Name: att_break; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_break (
    id integer NOT NULL,
    break_id integer NOT NULL,
    break_name character varying(64),
    break_start timestamp without time zone NOT NULL,
    break_advance timestamp without time zone,
    break_end timestamp without time zone NOT NULL,
    break_delay timestamp without time zone,
    break_autodeduct boolean,
    break_deductminute integer,
    break_overcount_paycode integer,
    break_overcount boolean,
    break_overminutes integer,
    break_earlycount_paycode integer,
    break_earlycount boolean,
    break_earlyminutes integer,
    break_needcheck boolean
);


ALTER TABLE public.att_break OWNER TO dba;

--
-- Name: att_break_timetable; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_break_timetable (
    break_id integer NOT NULL,
    timetable_id integer NOT NULL
);


ALTER TABLE public.att_break_timetable OWNER TO dba;

--
-- Name: att_day_details; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_day_details (
    id integer NOT NULL,
    att_date timestamp without time zone NOT NULL,
    sortindex integer NOT NULL,
    checkin timestamp without time zone,
    lunchin timestamp without time zone,
    lunchout timestamp without time zone,
    breakin timestamp without time zone,
    breakout timestamp without time zone,
    checkout timestamp without time zone,
    hours timestamp without time zone,
    worked timestamp without time zone,
    roundedin timestamp without time zone,
    roundedout timestamp without time zone,
    roundworked timestamp without time zone,
    iuser1 integer,
    iuser2 integer,
    iuser3 integer,
    cuser1 character varying(64),
    cuser2 character varying(64),
    cuser3 character varying(64),
    remark character varying(64),
    timetable_id integer,
    workcode_id integer,
    employee_id integer NOT NULL
);


ALTER TABLE public.att_day_details OWNER TO dba;

--
-- Name: att_day_summary; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_day_summary (
    id integer NOT NULL,
    att_date timestamp without time zone NOT NULL,
    pc_results numeric(19,5),
    iuser1 integer,
    iuser2 integer,
    iuser3 integer,
    cuser1 character varying(64),
    cuser2 character varying(64),
    cuser3 character varying(64),
    remark character varying(64),
    paycode_id integer NOT NULL,
    employee_id integer NOT NULL,
    timetable_id integer
);


ALTER TABLE public.att_day_summary OWNER TO dba;

--
-- Name: att_employee_shift; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_employee_shift (
    id integer NOT NULL,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    employee_id integer NOT NULL,
    shift_id integer NOT NULL,
    modifydate timestamp without time zone
);


ALTER TABLE public.att_employee_shift OWNER TO dba;

--
-- Name: att_employee_temp_shift; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_employee_temp_shift (
    id integer NOT NULL,
    paycodeavailable boolean,
    schdate timestamp without time zone,
    employee_id integer,
    timetable_id integer,
    paycode_id integer
);


ALTER TABLE public.att_employee_temp_shift OWNER TO dba;

--
-- Name: att_employee_zone; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_employee_zone (
    id integer NOT NULL,
    employee_id integer,
    zone_id integer NOT NULL
);


ALTER TABLE public.att_employee_zone OWNER TO dba;

--
-- Name: att_exceptionassign; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_exceptionassign (
    id integer NOT NULL,
    exception_date timestamp without time zone,
    starttime timestamp without time zone,
    endtime timestamp without time zone,
    paycode_id integer,
    employee_id integer
);


ALTER TABLE public.att_exceptionassign OWNER TO dba;

--
-- Name: att_flexibletimetable; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_flexibletimetable (
    id integer NOT NULL,
    worktimelimit integer,
    punchinterval integer,
    daychanged timestamp without time zone,
    otl1available boolean,
    otl1minutes integer,
    otl2available boolean,
    otl2minutes integer,
    otl3available boolean,
    otl3minutes integer,
    timetable_id integer NOT NULL
);


ALTER TABLE public.att_flexibletimetable OWNER TO dba;

--
-- Name: att_punches; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_punches (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    punch_time timestamp without time zone NOT NULL,
    workcode integer,
    workstate integer,
    verifycode character varying(64),
    terminal_id integer,
    punch_type character varying(64),
    operator character varying(64),
    operator_reason character varying(255),
    operator_time timestamp without time zone,
    isselect integer,
    middleware_id bigint,
    attendance_event character varying(64),
    login_combination integer,
    status integer,
    annotation character varying(255),
    processed integer
);


ALTER TABLE public.att_punches OWNER TO dba;

--
-- Name: att_shift; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_shift (
    id integer NOT NULL,
    shift_name character varying(64) NOT NULL,
    cycle_available boolean NOT NULL,
    cycle_type integer,
    cycle_parameter integer,
    start_date timestamp without time zone,
    defaultshift integer
);


ALTER TABLE public.att_shift OWNER TO dba;

--
-- Name: att_shift_details; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_shift_details (
    id integer NOT NULL,
    shift_date timestamp without time zone NOT NULL,
    timetable_paycode integer,
    paycode_available boolean,
    wc_available integer,
    timetable_wc integer,
    shift_id integer NOT NULL,
    timetable_id integer
);


ALTER TABLE public.att_shift_details OWNER TO dba;

--
-- Name: att_terminal; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_terminal (
    id integer NOT NULL,
    terminal_no integer NOT NULL,
    terminal_status integer NOT NULL,
    terminal_name character varying(64),
    terminal_location character varying(1024),
    terminal_category integer NOT NULL,
    terminal_type character varying(32),
    terminal_connectpwd character varying(32),
    terminal_domainname character varying(32),
    terminal_dateformat character varying(32),
    terminal_tcpip character varying(32),
    agr_version character varying(32),
    terminal_port integer,
    terminal_baudrate integer,
    terminal_users integer,
    terminal_fingerprints integer,
    terminal_faces integer,
    terminal_punches integer,
    isselect integer,
    terminal_sn bigint,
    policy integer,
    first_connect boolean,
    terminal_desc character varying(64),
    terminal_photostamp character varying(64),
    terminal_attlogstamp character varying(64),
    isfromwdms integer,
    connection_model integer,
    terminal_zem character varying(24),
    terminal_firmversion character varying(24),
    terminal_admins integer
);


ALTER TABLE public.att_terminal OWNER TO dba;

--
-- Name: att_terminal_events; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_terminal_events (
    id integer NOT NULL,
    occurtime timestamp without time zone,
    actionname character varying(128),
    contentdata character varying(1024),
    verifymode character varying(128),
    terminal_id integer NOT NULL
);


ALTER TABLE public.att_terminal_events OWNER TO dba;

--
-- Name: att_terminal_zone; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_terminal_zone (
    terminal_id integer NOT NULL,
    zone_id integer NOT NULL
);


ALTER TABLE public.att_terminal_zone OWNER TO dba;

--
-- Name: att_timetable; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_timetable (
    id integer NOT NULL,
    timetable_flexible boolean,
    timetable_name character varying(64),
    timetable_start timestamp without time zone,
    timetable_end timestamp without time zone,
    timetable_checkin_begin timestamp without time zone,
    timetable_checkin_end timestamp without time zone,
    timetable_checkout_begin timestamp without time zone,
    timetable_checkout_end timestamp without time zone,
    activeadvancesetting boolean,
    timetable_late boolean,
    timetable_latecome integer,
    timetable_early boolean,
    timetable_earlyout integer,
    timetable_roundtype integer,
    checkinroundvalue integer,
    checkoutroundvalue integer,
    checkinrounddown integer,
    checkoutrounddown integer,
    isaccesspunch boolean,
    needcheckin boolean,
    needcheckout boolean,
    countworktime integer,
    timetable_color integer,
    defaulttimetable integer
);


ALTER TABLE public.att_timetable OWNER TO dba;

--
-- Name: att_timetable_roundrule; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_timetable_roundrule (
    id integer NOT NULL,
    timefrom timestamp without time zone NOT NULL,
    timeto timestamp without time zone NOT NULL,
    roundtime timestamp without time zone NOT NULL,
    timetable_id integer NOT NULL
);


ALTER TABLE public.att_timetable_roundrule OWNER TO dba;

--
-- Name: att_workcode; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_workcode (
    id integer NOT NULL,
    wc_code integer NOT NULL,
    wc_name character varying(255) NOT NULL,
    middleware_code character varying(64),
    middleware_id bigint,
    wc_type bigint,
    description character varying(64)
);


ALTER TABLE public.att_workcode OWNER TO dba;

--
-- Name: att_workstate; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_workstate (
    id integer NOT NULL,
    ws_code integer NOT NULL,
    ws_alias character varying(64) NOT NULL
);


ALTER TABLE public.att_workstate OWNER TO dba;

--
-- Name: att_zone; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE att_zone (
    id integer NOT NULL,
    zone_code integer NOT NULL,
    clientid bigint,
    zonename character varying(64) NOT NULL,
    zoneid bigint,
    description character varying(64),
    iuser1 integer,
    cuser1 character varying(64),
    isselect integer,
    defaultzone integer
);


ALTER TABLE public.att_zone OWNER TO dba;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: dba
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO dba;

--
-- Name: hr_attendancerule; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_attendancerule (
    id integer NOT NULL,
    mininumtime integer,
    countnocheckin boolean,
    countpaycodenocheckin integer,
    countminutesnocheckin integer,
    countnocheckout boolean,
    countpaycodenocheckout integer,
    countminutesnocheckout integer,
    countabsentlateexceed boolean,
    countabsentlateexceedmins integer,
    countabsentearlyexceed boolean,
    countabsentearlyexceedmins integer,
    autoschedule boolean,
    countotbeforecheckin boolean,
    countotbeforeminscheckin integer,
    countotminsbeforecheckin integer,
    countotaftercheckout boolean,
    countotafterminscheckout integer,
    countotminsaftercheckout integer,
    limitotbeforecheckin boolean,
    limitotminsbeforecheckin integer,
    limitotaftercheckout boolean,
    limitotminsaftercheckout integer,
    limittotalot boolean,
    limittotalotmins integer,
    company_id integer
);


ALTER TABLE public.hr_attendancerule OWNER TO dba;

--
-- Name: hr_company; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_company (
    id integer NOT NULL,
    cmp_code character varying(10),
    cmp_dateformat character varying(64),
    cmp_timeformat character varying(64),
    cmp_name character varying(64) NOT NULL,
    cmp_operationmode integer,
    cmp_address1 character varying(512),
    cmp_address2 character varying(512),
    cmp_city character varying(64),
    cmp_state character varying(64),
    cmp_country character varying(64),
    cmp_postal character varying(6),
    cmp_phone character varying(13),
    cmp_fax character varying(13),
    cmp_email character varying(64),
    cmp_logo bytea,
    cmp_showlogoinreport boolean,
    cmp_website character varying(64)
);


ALTER TABLE public.hr_company OWNER TO dba;

--
-- Name: hr_delete_employee; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_delete_employee (
    id integer NOT NULL,
    emp_pin character varying(255) NOT NULL,
    terminal_id integer NOT NULL
);


ALTER TABLE public.hr_delete_employee OWNER TO dba;

--
-- Name: hr_department; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_department (
    id integer NOT NULL,
    dept_code integer NOT NULL,
    dept_name character varying(64) NOT NULL,
    dept_parentcode integer NOT NULL,
    dept_operationmode integer,
    middleware_id bigint,
    defaultdepartment integer,
    company_id integer NOT NULL,
    shift_id integer
);


ALTER TABLE public.hr_department OWNER TO dba;

--
-- Name: hr_employee; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_employee (
    id integer NOT NULL,
    emp_pin character varying(9) NOT NULL,
    emp_ssn character varying(64),
    emp_role character varying(64),
    emp_firstname character varying(64) NOT NULL,
    emp_lastname character varying(64),
    emp_username character varying(64),
    emp_pwd character varying(64),
    emp_timezone character varying(64),
    emp_phone character varying(13),
    emp_payroll_id character varying(64),
    emp_payroll_type character varying(64),
    emp_pin2 character varying(64),
    emp_photo bytea,
    emp_privilege character varying(64),
    emp_group character varying(64),
    emp_hiredate timestamp without time zone,
    emp_address character varying(64),
    emp_active integer NOT NULL,
    emp_firedate timestamp without time zone,
    emp_firereason character varying(1024),
    emp_emergencyphone1 character varying(13),
    emp_emergencyphone2 character varying(13),
    emp_emergencyname character varying(64),
    emp_emergencyaddress character varying(64),
    emp_cardnumber character varying(24),
    emp_country character varying(64),
    emp_city character varying(64),
    emp_state character varying(64),
    emp_postal character varying(6),
    emp_fax character varying(13),
    emp_email character varying(64),
    emp_title character varying(64),
    emp_hourlyrate1 numeric(19,5),
    emp_hourlyrate2 numeric(19,5),
    emp_hourlyrate3 numeric(19,5),
    emp_hourlyrate4 numeric(19,5),
    emp_hourlyrate5 numeric(19,5),
    emp_gender integer,
    emp_birthday timestamp without time zone,
    emp_operationmode integer,
    isselect integer,
    middleware_id bigint,
    nationalid character varying(64),
    department_id integer
);


ALTER TABLE public.hr_employee OWNER TO dba;

--
-- Name: hr_employee_group; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_employee_group (
    employee_id integer NOT NULL,
    groupitem_id integer NOT NULL
);


ALTER TABLE public.hr_employee_group OWNER TO dba;

--
-- Name: hr_group; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_group (
    id integer NOT NULL,
    group_name character varying(64) NOT NULL,
    employees character varying(64) NOT NULL
);


ALTER TABLE public.hr_group OWNER TO dba;

--
-- Name: hr_groupitem; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_groupitem (
    id integer NOT NULL,
    grp_item_id integer NOT NULL,
    grp_item_desc character varying(64) NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.hr_groupitem OWNER TO dba;

--
-- Name: hr_holiday_details; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_holiday_details (
    id integer NOT NULL,
    hor_code integer,
    hor_name character varying(255),
    hor_cycletype integer,
    hor_days integer,
    hor_date timestamp without time zone,
    hod_count integer,
    hod_count_type integer,
    hor_month_cycleyear integer,
    hor_day_cycleyear integer,
    hor_month_cycledate integer,
    hor_weeks_cycledate integer,
    hor_week_cycledate integer,
    company_id integer
);


ALTER TABLE public.hr_holiday_details OWNER TO dba;

--
-- Name: hr_payclass; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_payclass (
    id integer NOT NULL,
    sundayot1limit numeric(19,5),
    sundayot2limit numeric(19,5),
    sundayot3limit numeric(19,5),
    mondayot1limit numeric(19,5),
    mondayot2limit numeric(19,5),
    mondayot3limit numeric(19,5),
    tuesdayot1limit numeric(19,5),
    tuesdayot2limit numeric(19,5),
    tuesdayot3limit numeric(19,5),
    wednesdayot1limit numeric(19,5),
    wednesdayot2limit numeric(19,5),
    wednesdayot3limit numeric(19,5),
    thursdayot1limit numeric(19,5),
    thursdayot2limit numeric(19,5),
    thursdayot3limit numeric(19,5),
    fridayot1limit numeric(19,5),
    fridayot2limit numeric(19,5),
    fridayot3limit numeric(19,5),
    saturdayot1limit numeric(19,5),
    saturdayot2limit numeric(19,5),
    saturdayot3limit numeric(19,5),
    weekendset character varying(20),
    bweekendworkas boolean,
    weekendworkas integer,
    company_id integer
);


ALTER TABLE public.hr_payclass OWNER TO dba;

--
-- Name: hr_paycode; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_paycode (
    id integer NOT NULL,
    pc_code integer NOT NULL,
    pc_desc character varying(32),
    pc_type integer,
    export_code character varying(32),
    pc_delete boolean,
    sign character varying(2),
    min_value numeric(19,5),
    unit integer,
    round_type integer
);


ALTER TABLE public.hr_paycode OWNER TO dba;

--
-- Name: hr_template; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE hr_template (
    id integer NOT NULL,
    effective integer NOT NULL,
    template_type integer,
    template_len integer,
    template_str text,
    isforce integer,
    flag integer,
    template_index integer NOT NULL,
    action_group integer,
    salt character varying(255),
    pwd_str character varying(255),
    employee_id integer NOT NULL
);


ALTER TABLE public.hr_template OWNER TO dba;

--
-- Name: message; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE message (
    id integer NOT NULL,
    middle_message_id bigint NOT NULL,
    message_code integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    title character varying(64) NOT NULL,
    content character varying(255),
    message_type integer,
    send_emp_id integer,
    zone_id integer
);


ALTER TABLE public.message OWNER TO dba;

--
-- Name: message2entity; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE message2entity (
    id integer NOT NULL,
    readed integer NOT NULL,
    accept_emp_id integer,
    message_id integer NOT NULL
);


ALTER TABLE public.message2entity OWNER TO dba;

--
-- Name: pushqueue; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE pushqueue (
    id integer NOT NULL,
    content text NOT NULL,
    destination character varying(32) NOT NULL,
    cuser1 character varying(64)
);


ALTER TABLE public.pushqueue OWNER TO dba;

--
-- Name: reporttemplate; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE reporttemplate (
    id integer NOT NULL,
    title character varying(64) NOT NULL,
    template bytea,
    reportid character varying(64) NOT NULL,
    name character varying(64)
);


ALTER TABLE public.reporttemplate OWNER TO dba;

--
-- Name: salary_export; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE salary_export (
    id integer NOT NULL,
    export_code character varying(12) NOT NULL,
    export_index integer NOT NULL,
    pc_available character varying(1) NOT NULL,
    paycode_id integer NOT NULL,
    software_id integer NOT NULL
);


ALTER TABLE public.salary_export OWNER TO dba;

--
-- Name: salary_software; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE salary_software (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    local character varying(32) NOT NULL,
    flag character varying(8)
);


ALTER TABLE public.salary_software OWNER TO dba;

--
-- Name: sys_config; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_config (
    id integer NOT NULL,
    configtype smallint NOT NULL,
    data bytea
);


ALTER TABLE public.sys_config OWNER TO dba;

--
-- Name: sys_datafilter; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_datafilter (
    id integer NOT NULL,
    datafilter_desc character varying(64) NOT NULL,
    data_ranger character varying(1024) NOT NULL
);


ALTER TABLE public.sys_datafilter OWNER TO dba;

--
-- Name: sys_log; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_log (
    id integer NOT NULL,
    tablename character varying(50),
    operatetype character varying(50),
    operator character varying(50),
    log_date timestamp without time zone,
    message character varying(2048)
);


ALTER TABLE public.sys_log OWNER TO dba;

--
-- Name: sys_menu; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_menu (
    id integer NOT NULL,
    menuflag character varying(50) NOT NULL,
    menuno character varying(50) NOT NULL,
    parentno character varying(50) NOT NULL
);


ALTER TABLE public.sys_menu OWNER TO dba;

--
-- Name: sys_privilege; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_privilege (
    id integer NOT NULL,
    privilege_name character varying(64) NOT NULL,
    menu_id integer NOT NULL
);


ALTER TABLE public.sys_privilege OWNER TO dba;

--
-- Name: sys_role; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_role (
    id integer NOT NULL,
    role_name character varying(64) NOT NULL,
    remark character varying(64),
    role_type integer,
    defaultrole integer
);


ALTER TABLE public.sys_role OWNER TO dba;

--
-- Name: sys_role_datafilter; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_role_datafilter (
    role_df_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.sys_role_datafilter OWNER TO dba;

--
-- Name: sys_role_rights; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_role_rights (
    role_pri_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.sys_role_rights OWNER TO dba;

--
-- Name: sys_user; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_user (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    user_pwd character varying(32),
    user_email character varying(64) NOT NULL,
    remark character varying(64)
);


ALTER TABLE public.sys_user OWNER TO dba;

--
-- Name: sys_user_role; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE sys_user_role (
    role_id integer NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE public.sys_user_role OWNER TO dba;

--
-- Name: zkproto_control_queue; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE zkproto_control_queue (
    id integer NOT NULL,
    action integer NOT NULL,
    target integer NOT NULL,
    info character varying(255) NOT NULL,
    replace_zoneid bigint NOT NULL,
    create_time timestamp without time zone,
    sendout_time timestamp without time zone,
    return_time timestamp without time zone,
    return_flag integer,
    language_str character varying(255)
);


ALTER TABLE public.zkproto_control_queue OWNER TO dba;

--
-- Name: zkproto_sync_queue; Type: TABLE; Schema: public; Owner: dba; Tablespace: 
--

CREATE TABLE zkproto_sync_queue (
    id integer NOT NULL,
    op_id bigint NOT NULL,
    action integer NOT NULL,
    info character varying(255) NOT NULL,
    pressedtime bigint NOT NULL,
    zone_clientid bigint,
    sendout_time timestamp without time zone,
    return_time timestamp without time zone,
    return_flag integer,
    language_str character varying(255)
);


ALTER TABLE public.zkproto_sync_queue OWNER TO dba;

--
-- Data for Name: ac_group; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY ac_group (id, acgroup_id, acgroup_name, acgroup_holidayvalid, acgroup_verifystytle, timezone1, timezone2, timezone3, terminal_id) FROM stdin;
\.


--
-- Data for Name: ac_holidaysetting; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY ac_holidaysetting (holiday_id, holiday_name, holiday_start, holiday_end, actimezoneid) FROM stdin;
\.


--
-- Data for Name: ac_timezone; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY ac_timezone (timezone_id, timezone_name, timezone_sunstart, timezone_sunend, timezone_monstart, timezone_monend, timezone_tuesstart, timezone_tuesend, timezone_wedstart, timezone_wedend, timezone_thursstart, timezone_thursend, timezone_fristart, timezone_friend, timezone_satstart, timezone_satend) FROM stdin;
\.


--
-- Data for Name: ac_unlockcomb; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY ac_unlockcomb (id, unlockcomb_id, unlockcomb_name, acgroup1, acgroup2, acgroup3, acgroup4, acgroup5, terminal_id) FROM stdin;
\.


--
-- Data for Name: ac_userprivilege; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY ac_userprivilege (id, isusergroup, verifystytle, disable, employee_id, terminal_id, timezone1, timezone2, timezone3, acgroup_id) FROM stdin;
\.


--
-- Data for Name: att_break; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_break (id, break_id, break_name, break_start, break_advance, break_end, break_delay, break_autodeduct, break_deductminute, break_overcount_paycode, break_overcount, break_overminutes, break_earlycount_paycode, break_earlycount, break_earlyminutes, break_needcheck) FROM stdin;
\.


--
-- Data for Name: att_break_timetable; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_break_timetable (break_id, timetable_id) FROM stdin;
\.


--
-- Data for Name: att_day_details; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_day_details (id, att_date, sortindex, checkin, lunchin, lunchout, breakin, breakout, checkout, hours, worked, roundedin, roundedout, roundworked, iuser1, iuser2, iuser3, cuser1, cuser2, cuser3, remark, timetable_id, workcode_id, employee_id) FROM stdin;
\.


--
-- Data for Name: att_day_summary; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_day_summary (id, att_date, pc_results, iuser1, iuser2, iuser3, cuser1, cuser2, cuser3, remark, paycode_id, employee_id, timetable_id) FROM stdin;
\.


--
-- Data for Name: att_employee_shift; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_employee_shift (id, startdate, enddate, employee_id, shift_id, modifydate) FROM stdin;
\.


--
-- Data for Name: att_employee_temp_shift; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_employee_temp_shift (id, paycodeavailable, schdate, employee_id, timetable_id, paycode_id) FROM stdin;
\.


--
-- Data for Name: att_employee_zone; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_employee_zone (id, employee_id, zone_id) FROM stdin;
\.


--
-- Data for Name: att_exceptionassign; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_exceptionassign (id, exception_date, starttime, endtime, paycode_id, employee_id) FROM stdin;
\.


--
-- Data for Name: att_flexibletimetable; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_flexibletimetable (id, worktimelimit, punchinterval, daychanged, otl1available, otl1minutes, otl2available, otl2minutes, otl3available, otl3minutes, timetable_id) FROM stdin;
\.


--
-- Data for Name: att_punches; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_punches (id, employee_id, punch_time, workcode, workstate, verifycode, terminal_id, punch_type, operator, operator_reason, operator_time, isselect, middleware_id, attendance_event, login_combination, status, annotation, processed) FROM stdin;
\.


--
-- Data for Name: att_shift; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_shift (id, shift_name, cycle_available, cycle_type, cycle_parameter, start_date, defaultshift) FROM stdin;
6	Default	t	1	1	2014-06-30 00:00:00	1
\.


--
-- Data for Name: att_shift_details; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_shift_details (id, shift_date, timetable_paycode, paycode_available, wc_available, timetable_wc, shift_id, timetable_id) FROM stdin;
7	2014-06-30 00:00:00	0	f	0	0	6	5
8	2014-07-01 00:00:00	0	f	0	0	6	5
9	2014-07-02 00:00:00	0	f	0	0	6	5
10	2014-07-03 00:00:00	0	f	0	0	6	5
11	2014-07-04 00:00:00	0	f	0	0	6	5
12	2014-07-05 00:00:00	0	f	0	0	6	\N
13	2014-07-06 00:00:00	0	f	0	0	6	\N
\.


--
-- Data for Name: att_terminal; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_terminal (id, terminal_no, terminal_status, terminal_name, terminal_location, terminal_category, terminal_type, terminal_connectpwd, terminal_domainname, terminal_dateformat, terminal_tcpip, agr_version, terminal_port, terminal_baudrate, terminal_users, terminal_fingerprints, terminal_faces, terminal_punches, isselect, terminal_sn, policy, first_connect, terminal_desc, terminal_photostamp, terminal_attlogstamp, isfromwdms, connection_model, terminal_zem, terminal_firmversion, terminal_admins) FROM stdin;
\.


--
-- Data for Name: att_terminal_events; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_terminal_events (id, occurtime, actionname, contentdata, verifymode, terminal_id) FROM stdin;
\.


--
-- Data for Name: att_terminal_zone; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_terminal_zone (terminal_id, zone_id) FROM stdin;
\.


--
-- Data for Name: att_timetable; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_timetable (id, timetable_flexible, timetable_name, timetable_start, timetable_end, timetable_checkin_begin, timetable_checkin_end, timetable_checkout_begin, timetable_checkout_end, activeadvancesetting, timetable_late, timetable_latecome, timetable_early, timetable_earlyout, timetable_roundtype, checkinroundvalue, checkoutroundvalue, checkinrounddown, checkoutrounddown, isaccesspunch, needcheckin, needcheckout, countworktime, timetable_color, defaulttimetable) FROM stdin;
5	f	Default	1900-01-01 09:00:00	1900-01-01 18:00:00	1900-01-01 07:00:00	1900-01-01 11:00:00	1900-01-01 15:00:00	1900-01-01 22:00:00	f	f	0	f	0	0	0	0	0	0	f	f	f	540	-16744193	1
\.


--
-- Data for Name: att_timetable_roundrule; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_timetable_roundrule (id, timefrom, timeto, roundtime, timetable_id) FROM stdin;
\.


--
-- Data for Name: att_workcode; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_workcode (id, wc_code, wc_name, middleware_code, middleware_id, wc_type, description) FROM stdin;
\.


--
-- Data for Name: att_workstate; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_workstate (id, ws_code, ws_alias) FROM stdin;
161	0	CheckStatus1
162	1	CheckStatus2
163	2	CheckStatus3
164	3	CheckStatus4
165	4	CheckStatus5
166	5	CheckStatus6
167	6	CheckStatus7
\.


--
-- Data for Name: att_zone; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY att_zone (id, zone_code, clientid, zonename, zoneid, description, iuser1, cuser1, isselect, defaultzone) FROM stdin;
1	1	2943433448722331518	zone1	1	\N	0	\N	0	1
\.


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: dba
--

SELECT pg_catalog.setval('hibernate_sequence', 169, true);


--
-- Data for Name: hr_attendancerule; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_attendancerule (id, mininumtime, countnocheckin, countpaycodenocheckin, countminutesnocheckin, countnocheckout, countpaycodenocheckout, countminutesnocheckout, countabsentlateexceed, countabsentlateexceedmins, countabsentearlyexceed, countabsentearlyexceedmins, autoschedule, countotbeforecheckin, countotbeforeminscheckin, countotminsbeforecheckin, countotaftercheckout, countotafterminscheckout, countotminsaftercheckout, limitotbeforecheckin, limitotminsbeforecheckin, limitotaftercheckout, limitotminsaftercheckout, limittotalot, limittotalotmins, company_id) FROM stdin;
4	5	f	6	0	f	7	0	f	1	f	1	f	f	0	0	f	0	0	f	0	f	0	f	0	2
\.


--
-- Data for Name: hr_company; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_company (id, cmp_code, cmp_dateformat, cmp_timeformat, cmp_name, cmp_operationmode, cmp_address1, cmp_address2, cmp_city, cmp_state, cmp_country, cmp_postal, cmp_phone, cmp_fax, cmp_email, cmp_logo, cmp_showlogoinreport, cmp_website) FROM stdin;
2	1	\N	\N	Company	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N
\.


--
-- Data for Name: hr_delete_employee; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_delete_employee (id, emp_pin, terminal_id) FROM stdin;
\.


--
-- Data for Name: hr_department; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_department (id, dept_code, dept_name, dept_parentcode, dept_operationmode, middleware_id, defaultdepartment, company_id, shift_id) FROM stdin;
14	1	Department	0	0	0	1	2	6
\.


--
-- Data for Name: hr_employee; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_employee (id, emp_pin, emp_ssn, emp_role, emp_firstname, emp_lastname, emp_username, emp_pwd, emp_timezone, emp_phone, emp_payroll_id, emp_payroll_type, emp_pin2, emp_photo, emp_privilege, emp_group, emp_hiredate, emp_address, emp_active, emp_firedate, emp_firereason, emp_emergencyphone1, emp_emergencyphone2, emp_emergencyname, emp_emergencyaddress, emp_cardnumber, emp_country, emp_city, emp_state, emp_postal, emp_fax, emp_email, emp_title, emp_hourlyrate1, emp_hourlyrate2, emp_hourlyrate3, emp_hourlyrate4, emp_hourlyrate5, emp_gender, emp_birthday, emp_operationmode, isselect, middleware_id, nationalid, department_id) FROM stdin;
\.


--
-- Data for Name: hr_employee_group; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_employee_group (employee_id, groupitem_id) FROM stdin;
\.


--
-- Data for Name: hr_group; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_group (id, group_name, employees) FROM stdin;
\.


--
-- Data for Name: hr_groupitem; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_groupitem (id, grp_item_id, grp_item_desc, group_id) FROM stdin;
\.


--
-- Data for Name: hr_holiday_details; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_holiday_details (id, hor_code, hor_name, hor_cycletype, hor_days, hor_date, hod_count, hod_count_type, hor_month_cycleyear, hor_day_cycleyear, hor_month_cycledate, hor_weeks_cycledate, hor_week_cycledate, company_id) FROM stdin;
\.


--
-- Data for Name: hr_payclass; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_payclass (id, sundayot1limit, sundayot2limit, sundayot3limit, mondayot1limit, mondayot2limit, mondayot3limit, tuesdayot1limit, tuesdayot2limit, tuesdayot3limit, wednesdayot1limit, wednesdayot2limit, wednesdayot3limit, thursdayot1limit, thursdayot2limit, thursdayot3limit, fridayot1limit, fridayot2limit, fridayot3limit, saturdayot1limit, saturdayot2limit, saturdayot3limit, weekendset, bweekendworkas, weekendworkas, company_id) FROM stdin;
3	0.00000	0.00000	0.00000	9.00000	11.00000	14.00000	9.00000	11.00000	14.00000	9.00000	11.00000	14.00000	9.00000	11.00000	14.00000	9.00000	11.00000	14.00000	9.00000	11.00000	14.00000	6,0,	f	0	2
\.


--
-- Data for Name: hr_paycode; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_paycode (id, pc_code, pc_desc, pc_type, export_code, pc_delete, sign, min_value, unit, round_type) FROM stdin;
15	1	total	0	\N	f	\N	0.00000	0	0
16	2	work	0	\N	f	\N	0.00000	0	0
17	3	overtime1	0	\N	f	\N	0.00000	0	0
18	4	overtime2	0	\N	f	\N	0.00000	0	0
19	5	overtime3	0	\N	f	\N	0.00000	0	0
20	6	lateCome	0	\N	f	\N	0.00000	0	0
21	7	earlyOut	0	\N	f	\N	0.00000	0	0
22	8	absence	0	\N	f	\N	0.00000	0	0
23	9	break	0	\N	f	\N	0.00000	0	0
24	10	holiday	0	\N	f	\N	0.00000	0	0
25	11	sick	0	\N	f	\N	0.00000	0	0
26	12	vacation	0	\N	f	\N	0.00000	0	0
\.


--
-- Data for Name: hr_template; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY hr_template (id, effective, template_type, template_len, template_str, isforce, flag, template_index, action_group, salt, pwd_str, employee_id) FROM stdin;
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY message (id, middle_message_id, message_code, start_time, end_time, title, content, message_type, send_emp_id, zone_id) FROM stdin;
\.


--
-- Data for Name: message2entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY message2entity (id, readed, accept_emp_id, message_id) FROM stdin;
\.


--
-- Data for Name: pushqueue; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY pushqueue (id, content, destination, cuser1) FROM stdin;
\.


--
-- Data for Name: reporttemplate; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY reporttemplate (id, title, template, reportid, name) FROM stdin;
28	Transactions Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d020000000603000000135472616e73616374696f6e73205265706f72740a0a0100000a0a0a0b	AttendanceReport_01	Transactions
29	Daily Total Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d020000000603000000124461696c7920546f74616c205265706f72740a0a0100000a0a0a0b	AttendanceReport_02	Daily Total
30	TimeCard Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d0200000006030000000f54696d6543617264205265706f72740a0a0100000a0a0a0b	AttendanceReport_03	TimeCard
31	Total TimeCard Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d02000000060300000015546f74616c2054696d6543617264205265706f72740a0a0100000a0a0a0b	AttendanceReport_04	Total TimeCard
32	Early Out Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d020000000603000000104561726c79204f7574205265706f72740a0a0100000a0a0a0b	AttendanceReport_05	Early Out
33	Late Come Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d020000000603000000104c61746520436f6d65205265706f72740a0a0100000a0a0a0b	AttendanceReport_06	Late Come
34	Absence Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d0200000006030000000e416273656e6365205265706f72740a0a0100000a0a0a0b	AttendanceReport_07	Absence
35	Employee Shift Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d02000000060300000015456d706c6f796565205368696674205265706f72740a0a0100000a0a0a0b	AttendanceReport_08	Employee Shift
36	Exception Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d02000000060300000010457863657074696f6e205265706f72740a0a0100000a0a0a0b	AttendanceReport_09	Exception
37	Hours Summary Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d02000000060300000014486f7572732053756d6d617279205265706f72740a0a0100000a0a0a0b	AttendanceReport_10	Hours Summary
38	TimeCard List Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d0200000006030000001454696d6543617264204c697374205265706f72740a0a0100000a0a0a0b	AttendanceReport_11	TimeCard List
39	Attendance Card Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d02000000060300000016417474656e64616e63652043617264205265706f72740a0a0100000a0a0a0b	AttendanceReport_12	Attendance Card
40	Daily Attendance Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d020000000603000000174461696c7920417474656e64616e6365205265706f72740a0a0100000a0a0a0b	AttendanceReport_13	Daily Attendance
41	Monthly Summary Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d020000000603000000164d6f6e74686c792053756d6d617279205265706f72740a0a0100000a0a0a0b	AttendanceReport_14	Monthly Summary
42	Flexible Schedule Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000385a4b54696d654e65742e456e7469746965732e5265706f72742e417474656e64616e63655265706f727454656d706c617465456e7469747909000000163c5469746c653e6b5f5f4261636b696e674669656c64193c466f726d446174653e6b5f5f4261636b696e674669656c64173c546f446174653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c640101010000000303010101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d02000000060300000018466c657869626c65205363686564756c65205265706f72740a0a0100000a0a0a0b	AttendanceReport_15	Flexible Schedule
43	Employee Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000365a4b54696d654e65742e456e7469746965732e5265706f72742e456d706c6f7965655265706f727454656d706c617465456e7469747908000000163c5469746c653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c641d3c44697370616c794669656c643e6b5f5f4261636b696e674669656c6401000000030301030101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d9c0153797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b5a4b54696d654e65742e476c6f62616c2e436f72652e53656c6563746564436f6c756d6e496e666f2c205a4b54696d654e65742e476c6f62616c2e436f72652c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c5d5d0200000006030000000f456d706c6f796565205265706f72740100000a0a0a0a0b	EmployeeReport_01	Employee
44	Employee Information Report	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0501000000365a4b54696d654e65742e456e7469746965732e5265706f72742e456d706c6f7965655265706f727454656d706c617465456e7469747908000000163c5469746c653e6b5f5f4261636b696e674669656c64293c53656c656374416c6c456d706c6f796565436865636b65643e6b5f5f4261636b696e674669656c64233c53656c65637447726f7570436865636b65643e6b5f5f4261636b696e674669656c642a3c53656c656374456d706c6f7965654c697374436865636b65643e6b5f5f4261636b696e674669656c64223c53656c656374656447726f75704c6973743e6b5f5f4261636b696e674669656c64263c53656c6563746564456d706c6f796565734c6973743e6b5f5f4261636b696e674669656c64183c4f7264657242793e6b5f5f4261636b696e674669656c641d3c44697370616c794669656c643e6b5f5f4261636b696e674669656c6401000000030301030101017e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d7e53797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b53797374656d2e496e7433322c206d73636f726c69622c2056657273696f6e3d342e302e302e302c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d623737613563353631393334653038395d5d9c0153797374656d2e436f6c6c656374696f6e732e47656e657269632e4c69737460315b5b5a4b54696d654e65742e476c6f62616c2e436f72652e53656c6563746564436f6c756d6e496e666f2c205a4b54696d654e65742e476c6f62616c2e436f72652c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c5d5d0200000006030000001b456d706c6f79656520496e666f726d6174696f6e205265706f72740100000a0a0a0a0b	EmployeeReport_02	Employee Information
\.


--
-- Data for Name: salary_export; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY salary_export (id, export_code, export_index, pc_available, paycode_id, software_id) FROM stdin;
\.


--
-- Data for Name: salary_software; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY salary_software (id, name, local, flag) FROM stdin;
\.


--
-- Data for Name: sys_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_config (id, configtype, data) FROM stdin;
27	4	\\x0001000000ffffffff01000000000000000c020000004a5a4b54696d654e65742e456e7469746965732c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c0c030000004d5a4b54696d654e65742e476c6f62616c2e436f72652c2056657273696f6e3d332e302e302e32322c2043756c747572653d6e65757472616c2c205075626c69634b6579546f6b656e3d6e756c6c05010000002c5a4b54696d654e65742e456e7469746965732e53797374656d2e53797374656d4f7074696f6e456e74697479040000001e3c64656c65746570756e636865733e6b5f5f4261636b696e674669656c641b3c64617465666f726d61743e6b5f5f4261636b696e674669656c641b3c74696d65666f726d61743e6b5f5f4261636b696e674669656c641d3c63616c656e646172747970653e6b5f5f4261636b696e674669656c640001010401225a4b54696d654e65742e476c6f62616c2e436f72652e43616c656e6461725479706503000000020000000006040000000a4d4d2f64642f7979797906050000000548483a6d6d05faffffff225a4b54696d654e65742e476c6f62616c2e436f72652e43616c656e64617254797065010000000776616c75655f5f000803000000000000000b
\.


--
-- Data for Name: sys_datafilter; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_datafilter (id, datafilter_desc, data_ranger) FROM stdin;
160	cmp	All
\.


--
-- Data for Name: sys_log; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_log (id, tablename, operatetype, operator, log_date, message) FROM stdin;
169		Login	dba	2015-06-12 10:42:34	Login System
\.


--
-- Data for Name: sys_menu; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_menu (id, menuflag, menuno, parentno) FROM stdin;
45	Config	050505	0505
48	EmailSet	050510	0505
51	Role	050515	0505
55	User	050520	0505
59	OperatorLog	050525	0505
63	Database	050530	0505
68	Companies	051005	0510
71	Employees	051010	0510
78	PayCode	051015	0510
82	Rules	051525	0515
85	Timetable	051505	0515
89	Shifts	051510	0515
94	Schedule	051515	0515
97	ExceptionAssign	051520	0515
101	DeviceManagement	052005	0520
108	TerminalGroup	052010	0520
114	DataSync	052015	0520
117	ImportExport	052020	0520
119	workcode	052025	0520
123	Message	052030	0520
127	ACTimezone	052505	0525
131	ACGroup	052510	0525
135	ACUnlockComb	052515	0525
138	UserACPrivilege	052520	0525
142	UploadACPrivilege	052525	0525
145	Punches	053005	0530
151	Calculate	053010	0530
154	AttReport	053015	0530
\.


--
-- Data for Name: sys_privilege; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_privilege (id, privilege_name, menu_id) FROM stdin;
155	Select	154
156	Update	154
110	Update	108
92	Delete	89
46	Select	45
153	Update	151
144	Assign2Device	142
143	Select	142
57	Update	55
64	Select	63
122	Delete	119
61	Delete	59
62	Export	59
99	Update	97
104	Delete	101
95	Select	94
105	DownloadPunches	101
136	Select	135
107	DownloadPhotos	101
120	Select	119
132	Select	131
152	Select	151
103	Update	101
93	Assign	89
111	Delete	108
66	BackupDB	63
75	Import	71
91	Update	89
81	Delete	78
109	Select	108
74	Delete	71
129	Update	127
158	View	154
56	Select	55
113	AssignDevice	108
148	Delete	145
141	Delete	138
73	Update	71
84	Update	82
102	Select	101
58	Delete	55
87	Update	85
90	Select	89
115	Select	114
147	Update	145
80	Update	78
96	Update	94
124	Select	123
134	Delete	131
70	Update	68
116	DataSync	114
50	Update	48
65	InitialDB	63
118	Select	117
69	Select	68
112	AssignEmployee	108
53	Update	51
60	Select	59
133	Update	131
157	Delete	154
130	Delete	127
54	Delete	51
140	Update	138
125	Update	123
47	Update	45
100	Delete	97
83	Select	82
150	Export	145
98	Select	97
72	Select	71
146	Select	145
139	Select	138
76	Export	71
88	Delete	85
137	Update	135
77	BatchUpdate	71
79	Select	78
121	Update	119
49	Select	48
128	Select	127
52	Select	51
149	Import	145
126	Delete	123
67	RestoreDB	63
106	SearchTerminal	101
86	Select	85
\.


--
-- Data for Name: sys_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_role (id, role_name, remark, role_type, defaultrole) FROM stdin;
159	Administrator	\N	1	1
\.


--
-- Data for Name: sys_role_datafilter; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_role_datafilter (role_df_id, role_id) FROM stdin;
160	159
\.


--
-- Data for Name: sys_role_rights; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_role_rights (role_pri_id, role_id) FROM stdin;
46	159
47	159
49	159
50	159
52	159
53	159
54	159
56	159
57	159
58	159
60	159
61	159
62	159
64	159
65	159
66	159
67	159
69	159
70	159
72	159
73	159
74	159
75	159
76	159
77	159
79	159
80	159
81	159
83	159
84	159
86	159
87	159
88	159
90	159
91	159
92	159
93	159
95	159
96	159
98	159
99	159
100	159
102	159
103	159
104	159
105	159
106	159
107	159
109	159
110	159
111	159
112	159
113	159
115	159
116	159
118	159
120	159
121	159
122	159
124	159
125	159
126	159
128	159
129	159
130	159
132	159
133	159
134	159
136	159
137	159
139	159
140	159
141	159
143	159
144	159
146	159
147	159
148	159
149	159
150	159
152	159
153	159
155	159
156	159
157	159
158	159
\.


--
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_user (id, username, user_pwd, user_email, remark) FROM stdin;
168	dba	sql123	cornelioroyer@hotmail.com	\N
\.


--
-- Data for Name: sys_user_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY sys_user_role (role_id, userid) FROM stdin;
159	168
\.


--
-- Data for Name: zkproto_control_queue; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY zkproto_control_queue (id, action, target, info, replace_zoneid, create_time, sendout_time, return_time, return_flag, language_str) FROM stdin;
\.


--
-- Data for Name: zkproto_sync_queue; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY zkproto_sync_queue (id, op_id, action, info, pressedtime, zone_clientid, sendout_time, return_time, return_flag, language_str) FROM stdin;
\.


--
-- Name: ac_group_acgroup_id_terminal_id_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_group
    ADD CONSTRAINT ac_group_acgroup_id_terminal_id_key UNIQUE (acgroup_id, terminal_id);


--
-- Name: ac_group_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_group
    ADD CONSTRAINT ac_group_pkey PRIMARY KEY (id);


--
-- Name: ac_holidaysetting_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_holidaysetting
    ADD CONSTRAINT ac_holidaysetting_pkey PRIMARY KEY (holiday_id);


--
-- Name: ac_timezone_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_timezone
    ADD CONSTRAINT ac_timezone_pkey PRIMARY KEY (timezone_id);


--
-- Name: ac_unlockcomb_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT ac_unlockcomb_pkey PRIMARY KEY (id);


--
-- Name: ac_unlockcomb_unlockcomb_id_terminal_id_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT ac_unlockcomb_unlockcomb_id_terminal_id_key UNIQUE (unlockcomb_id, terminal_id);


--
-- Name: ac_userprivilege_employee_id_terminal_id_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT ac_userprivilege_employee_id_terminal_id_key UNIQUE (employee_id, terminal_id);


--
-- Name: ac_userprivilege_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT ac_userprivilege_pkey PRIMARY KEY (id);


--
-- Name: att_break_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_break
    ADD CONSTRAINT att_break_pkey PRIMARY KEY (id);


--
-- Name: att_day_details_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_day_details
    ADD CONSTRAINT att_day_details_pkey PRIMARY KEY (id);


--
-- Name: att_day_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_day_summary
    ADD CONSTRAINT att_day_summary_pkey PRIMARY KEY (id);


--
-- Name: att_employee_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_employee_shift
    ADD CONSTRAINT att_employee_shift_pkey PRIMARY KEY (id);


--
-- Name: att_employee_temp_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_employee_temp_shift
    ADD CONSTRAINT att_employee_temp_shift_pkey PRIMARY KEY (id);


--
-- Name: att_employee_temp_shift_schdate_employee_id_timetable_id_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_employee_temp_shift
    ADD CONSTRAINT att_employee_temp_shift_schdate_employee_id_timetable_id_key UNIQUE (schdate, employee_id, timetable_id);


--
-- Name: att_employee_zone_employee_id_zone_id_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_employee_zone
    ADD CONSTRAINT att_employee_zone_employee_id_zone_id_key UNIQUE (employee_id, zone_id);


--
-- Name: att_employee_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_employee_zone
    ADD CONSTRAINT att_employee_zone_pkey PRIMARY KEY (id);


--
-- Name: att_exceptionassign_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_exceptionassign
    ADD CONSTRAINT att_exceptionassign_pkey PRIMARY KEY (id);


--
-- Name: att_flexibletimetable_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_flexibletimetable
    ADD CONSTRAINT att_flexibletimetable_pkey PRIMARY KEY (id);


--
-- Name: att_punches_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_punches
    ADD CONSTRAINT att_punches_pkey PRIMARY KEY (id);


--
-- Name: att_shift_details_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_shift_details
    ADD CONSTRAINT att_shift_details_pkey PRIMARY KEY (id);


--
-- Name: att_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_shift
    ADD CONSTRAINT att_shift_pkey PRIMARY KEY (id);


--
-- Name: att_terminal_events_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_terminal_events
    ADD CONSTRAINT att_terminal_events_pkey PRIMARY KEY (id);


--
-- Name: att_terminal_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_terminal
    ADD CONSTRAINT att_terminal_pkey PRIMARY KEY (id);


--
-- Name: att_timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_timetable
    ADD CONSTRAINT att_timetable_pkey PRIMARY KEY (id);


--
-- Name: att_timetable_roundrule_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_timetable_roundrule
    ADD CONSTRAINT att_timetable_roundrule_pkey PRIMARY KEY (id);


--
-- Name: att_workcode_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_workcode
    ADD CONSTRAINT att_workcode_pkey PRIMARY KEY (id);


--
-- Name: att_workstate_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_workstate
    ADD CONSTRAINT att_workstate_pkey PRIMARY KEY (id);


--
-- Name: att_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY att_zone
    ADD CONSTRAINT att_zone_pkey PRIMARY KEY (id);


--
-- Name: hr_attendancerule_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_attendancerule
    ADD CONSTRAINT hr_attendancerule_pkey PRIMARY KEY (id);


--
-- Name: hr_company_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_company
    ADD CONSTRAINT hr_company_pkey PRIMARY KEY (id);


--
-- Name: hr_delete_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_delete_employee
    ADD CONSTRAINT hr_delete_employee_pkey PRIMARY KEY (id);


--
-- Name: hr_department_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_department
    ADD CONSTRAINT hr_department_pkey PRIMARY KEY (id);


--
-- Name: hr_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_employee
    ADD CONSTRAINT hr_employee_pkey PRIMARY KEY (id);


--
-- Name: hr_group_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_group
    ADD CONSTRAINT hr_group_pkey PRIMARY KEY (id);


--
-- Name: hr_groupitem_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_groupitem
    ADD CONSTRAINT hr_groupitem_pkey PRIMARY KEY (id);


--
-- Name: hr_holiday_details_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_holiday_details
    ADD CONSTRAINT hr_holiday_details_pkey PRIMARY KEY (id);


--
-- Name: hr_payclass_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_payclass
    ADD CONSTRAINT hr_payclass_pkey PRIMARY KEY (id);


--
-- Name: hr_paycode_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_paycode
    ADD CONSTRAINT hr_paycode_pkey PRIMARY KEY (id);


--
-- Name: hr_template_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY hr_template
    ADD CONSTRAINT hr_template_pkey PRIMARY KEY (id);


--
-- Name: message2entity_accept_emp_id_message_id_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY message2entity
    ADD CONSTRAINT message2entity_accept_emp_id_message_id_key UNIQUE (accept_emp_id, message_id);


--
-- Name: message2entity_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY message2entity
    ADD CONSTRAINT message2entity_pkey PRIMARY KEY (id);


--
-- Name: message_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: pushqueue_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY pushqueue
    ADD CONSTRAINT pushqueue_pkey PRIMARY KEY (id);


--
-- Name: reporttemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY reporttemplate
    ADD CONSTRAINT reporttemplate_pkey PRIMARY KEY (id);


--
-- Name: salary_export_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY salary_export
    ADD CONSTRAINT salary_export_pkey PRIMARY KEY (id);


--
-- Name: salary_software_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY salary_software
    ADD CONSTRAINT salary_software_pkey PRIMARY KEY (id);


--
-- Name: sys_config_configtype_key; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_config
    ADD CONSTRAINT sys_config_configtype_key UNIQUE (configtype);


--
-- Name: sys_config_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_config
    ADD CONSTRAINT sys_config_pkey PRIMARY KEY (id);


--
-- Name: sys_datafilter_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_datafilter
    ADD CONSTRAINT sys_datafilter_pkey PRIMARY KEY (id);


--
-- Name: sys_log_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_log
    ADD CONSTRAINT sys_log_pkey PRIMARY KEY (id);


--
-- Name: sys_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_menu
    ADD CONSTRAINT sys_menu_pkey PRIMARY KEY (id);


--
-- Name: sys_privilege_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_privilege
    ADD CONSTRAINT sys_privilege_pkey PRIMARY KEY (id);


--
-- Name: sys_role_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_role
    ADD CONSTRAINT sys_role_pkey PRIMARY KEY (id);


--
-- Name: sys_user_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY sys_user
    ADD CONSTRAINT sys_user_pkey PRIMARY KEY (id);


--
-- Name: zkproto_control_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY zkproto_control_queue
    ADD CONSTRAINT zkproto_control_queue_pkey PRIMARY KEY (id);


--
-- Name: zkproto_sync_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: dba; Tablespace: 
--

ALTER TABLE ONLY zkproto_sync_queue
    ADD CONSTRAINT zkproto_sync_queue_pkey PRIMARY KEY (id);


--
-- Name: fk2463bbccf2cd5742; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_holiday_details
    ADD CONSTRAINT fk2463bbccf2cd5742 FOREIGN KEY (company_id) REFERENCES hr_company(id);


--
-- Name: fk25f61bd011a89f65; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_timetable_roundrule
    ADD CONSTRAINT fk25f61bd011a89f65 FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fk263aec8dc3d7f91b; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_groupitem
    ADD CONSTRAINT fk263aec8dc3d7f91b FOREIGN KEY (group_id) REFERENCES hr_group(id);


--
-- Name: fk27b969f611a89f65; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_flexibletimetable
    ADD CONSTRAINT fk27b969f611a89f65 FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fk3210fa9bf2cd5742; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_payclass
    ADD CONSTRAINT fk3210fa9bf2cd5742 FOREIGN KEY (company_id) REFERENCES hr_company(id);


--
-- Name: fk416e74b1114aa329; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_shift
    ADD CONSTRAINT fk416e74b1114aa329 FOREIGN KEY (shift_id) REFERENCES att_shift(id);


--
-- Name: fk416e74b150f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_shift
    ADD CONSTRAINT fk416e74b150f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk5750acf11a89f65; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_day_details
    ADD CONSTRAINT fk5750acf11a89f65 FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fk5750acf50f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_day_details
    ADD CONSTRAINT fk5750acf50f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk5750acfdb793422; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_day_details
    ADD CONSTRAINT fk5750acfdb793422 FOREIGN KEY (workcode_id) REFERENCES att_workcode(id);


--
-- Name: fk63030a9050f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_punches
    ADD CONSTRAINT fk63030a9050f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk63030a9060342464; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_punches
    ADD CONSTRAINT fk63030a9060342464 FOREIGN KEY (terminal_id) REFERENCES att_terminal(id);


--
-- Name: fk78355a14114aa329; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_shift_details
    ADD CONSTRAINT fk78355a14114aa329 FOREIGN KEY (shift_id) REFERENCES att_shift(id);


--
-- Name: fk78355a1411a89f65; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_shift_details
    ADD CONSTRAINT fk78355a1411a89f65 FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fk93228dc1cdb5df20; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_employee
    ADD CONSTRAINT fk93228dc1cdb5df20 FOREIGN KEY (department_id) REFERENCES hr_department(id);


--
-- Name: fk974373c64fd7515b; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY salary_export
    ADD CONSTRAINT fk974373c64fd7515b FOREIGN KEY (software_id) REFERENCES salary_software(id);


--
-- Name: fk974373c68fb14498; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY salary_export
    ADD CONSTRAINT fk974373c68fb14498 FOREIGN KEY (paycode_id) REFERENCES hr_paycode(id);


--
-- Name: fk9b3b5975114aa329; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_department
    ADD CONSTRAINT fk9b3b5975114aa329 FOREIGN KEY (shift_id) REFERENCES att_shift(id);


--
-- Name: fk9b3b5975f2cd5742; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_department
    ADD CONSTRAINT fk9b3b5975f2cd5742 FOREIGN KEY (company_id) REFERENCES hr_company(id);


--
-- Name: fk9d3ba7c350f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_exceptionassign
    ADD CONSTRAINT fk9d3ba7c350f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk9d3ba7c38fb14498; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_exceptionassign
    ADD CONSTRAINT fk9d3ba7c38fb14498 FOREIGN KEY (paycode_id) REFERENCES hr_paycode(id);


--
-- Name: fk_breaktimetable; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_break_timetable
    ADD CONSTRAINT fk_breaktimetable FOREIGN KEY (break_id) REFERENCES att_break(id);


--
-- Name: fk_datafilterrole; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_role_datafilter
    ADD CONSTRAINT fk_datafilterrole FOREIGN KEY (role_df_id) REFERENCES sys_datafilter(id);


--
-- Name: fk_employeegroup; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_employee_group
    ADD CONSTRAINT fk_employeegroup FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk_employeezone; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_zone
    ADD CONSTRAINT fk_employeezone FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk_groupemployee; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_employee_group
    ADD CONSTRAINT fk_groupemployee FOREIGN KEY (groupitem_id) REFERENCES hr_groupitem(id);


--
-- Name: fk_groupterminal; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_group
    ADD CONSTRAINT fk_groupterminal FOREIGN KEY (terminal_id) REFERENCES att_terminal(id);


--
-- Name: fk_grouptimezone1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_group
    ADD CONSTRAINT fk_grouptimezone1 FOREIGN KEY (timezone1) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_grouptimezone2; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_group
    ADD CONSTRAINT fk_grouptimezone2 FOREIGN KEY (timezone2) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_grouptimezone3; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_group
    ADD CONSTRAINT fk_grouptimezone3 FOREIGN KEY (timezone3) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_holidaytimezone; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_holidaysetting
    ADD CONSTRAINT fk_holidaytimezone FOREIGN KEY (actimezoneid) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_menuprivilege; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_privilege
    ADD CONSTRAINT fk_menuprivilege FOREIGN KEY (menu_id) REFERENCES sys_menu(id);


--
-- Name: fk_messageacceptemployee; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY message2entity
    ADD CONSTRAINT fk_messageacceptemployee FOREIGN KEY (accept_emp_id) REFERENCES hr_employee(id);


--
-- Name: fk_messageentity; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY message2entity
    ADD CONSTRAINT fk_messageentity FOREIGN KEY (message_id) REFERENCES message(id);


--
-- Name: fk_messagesendemployee; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY message
    ADD CONSTRAINT fk_messagesendemployee FOREIGN KEY (send_emp_id) REFERENCES hr_employee(id);


--
-- Name: fk_privilegeemployee; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT fk_privilegeemployee FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fk_privilegegroup; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT fk_privilegegroup FOREIGN KEY (acgroup_id) REFERENCES ac_group(id);


--
-- Name: fk_privilegerole; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_role_rights
    ADD CONSTRAINT fk_privilegerole FOREIGN KEY (role_pri_id) REFERENCES sys_privilege(id);


--
-- Name: fk_privilegeterminal; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT fk_privilegeterminal FOREIGN KEY (terminal_id) REFERENCES att_terminal(id);


--
-- Name: fk_privilegetimezone1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT fk_privilegetimezone1 FOREIGN KEY (timezone1) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_privilegetimezone2; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT fk_privilegetimezone2 FOREIGN KEY (timezone2) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_privilegetimezone3; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_userprivilege
    ADD CONSTRAINT fk_privilegetimezone3 FOREIGN KEY (timezone3) REFERENCES ac_timezone(timezone_id);


--
-- Name: fk_roledatafilter; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_role_datafilter
    ADD CONSTRAINT fk_roledatafilter FOREIGN KEY (role_id) REFERENCES sys_role(id);


--
-- Name: fk_roleprivilege; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_role_rights
    ADD CONSTRAINT fk_roleprivilege FOREIGN KEY (role_id) REFERENCES sys_role(id);


--
-- Name: fk_roleuser; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_user_role
    ADD CONSTRAINT fk_roleuser FOREIGN KEY (role_id) REFERENCES sys_role(id);


--
-- Name: fk_terminalzone; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_terminal_zone
    ADD CONSTRAINT fk_terminalzone FOREIGN KEY (terminal_id) REFERENCES att_terminal(id);


--
-- Name: fk_timetablebreak; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_break_timetable
    ADD CONSTRAINT fk_timetablebreak FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fk_unlockcombgroup1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT fk_unlockcombgroup1 FOREIGN KEY (acgroup1) REFERENCES ac_group(id);


--
-- Name: fk_unlockcombgroup2; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT fk_unlockcombgroup2 FOREIGN KEY (acgroup2) REFERENCES ac_group(id);


--
-- Name: fk_unlockcombgroup3; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT fk_unlockcombgroup3 FOREIGN KEY (acgroup3) REFERENCES ac_group(id);


--
-- Name: fk_unlockcombgroup4; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT fk_unlockcombgroup4 FOREIGN KEY (acgroup4) REFERENCES ac_group(id);


--
-- Name: fk_unlockcombgroup5; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT fk_unlockcombgroup5 FOREIGN KEY (acgroup5) REFERENCES ac_group(id);


--
-- Name: fk_unlockcombterminal; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY ac_unlockcomb
    ADD CONSTRAINT fk_unlockcombterminal FOREIGN KEY (terminal_id) REFERENCES att_terminal(id);


--
-- Name: fk_userrole; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY sys_user_role
    ADD CONSTRAINT fk_userrole FOREIGN KEY (userid) REFERENCES sys_user(id);


--
-- Name: fk_zoneemployee; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_zone
    ADD CONSTRAINT fk_zoneemployee FOREIGN KEY (zone_id) REFERENCES att_zone(id);


--
-- Name: fk_zonemessage; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY message
    ADD CONSTRAINT fk_zonemessage FOREIGN KEY (zone_id) REFERENCES att_zone(id);


--
-- Name: fk_zoneterminal; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_terminal_zone
    ADD CONSTRAINT fk_zoneterminal FOREIGN KEY (zone_id) REFERENCES att_zone(id);


--
-- Name: fka0f2a3b0f2cd5742; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_attendancerule
    ADD CONSTRAINT fka0f2a3b0f2cd5742 FOREIGN KEY (company_id) REFERENCES hr_company(id);


--
-- Name: fka0fc950260342464; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_terminal_events
    ADD CONSTRAINT fka0fc950260342464 FOREIGN KEY (terminal_id) REFERENCES att_terminal(id);


--
-- Name: fkc59c763c50f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY hr_template
    ADD CONSTRAINT fkc59c763c50f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fkf0203fad11a89f65; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_day_summary
    ADD CONSTRAINT fkf0203fad11a89f65 FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fkf0203fad50f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_day_summary
    ADD CONSTRAINT fkf0203fad50f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fkf0203fad8fb14498; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_day_summary
    ADD CONSTRAINT fkf0203fad8fb14498 FOREIGN KEY (paycode_id) REFERENCES hr_paycode(id);


--
-- Name: fkf1ae72e11a89f65; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_temp_shift
    ADD CONSTRAINT fkf1ae72e11a89f65 FOREIGN KEY (timetable_id) REFERENCES att_timetable(id);


--
-- Name: fkf1ae72e50f52429; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_temp_shift
    ADD CONSTRAINT fkf1ae72e50f52429 FOREIGN KEY (employee_id) REFERENCES hr_employee(id);


--
-- Name: fkf1ae72e8fb14498; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY att_employee_temp_shift
    ADD CONSTRAINT fkf1ae72e8fb14498 FOREIGN KEY (paycode_id) REFERENCES hr_paycode(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

