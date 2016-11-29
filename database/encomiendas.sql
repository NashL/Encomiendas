--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

-- Started on 2016-11-29 16:56:51 PET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12435)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 217 (class 1255 OID 95371)
-- Name: actualizar_entrega(bigint, bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION actualizar_entrega(bigint, bigint, bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	UPDATE entrega
	SET id_presupuesto=$2,id_cliente=$3
	WHERE entrega.id=$1;
END
$_$;


ALTER FUNCTION public.actualizar_entrega(bigint, bigint, bigint) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 95372)
-- Name: actualizar_paquete(bigint, character varying, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION actualizar_paquete(bigint, character varying, double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	UPDATE paquete
	SET descripcion=$2,peso=$3
	WHERE paquete.id=$1;
END
$_$;


ALTER FUNCTION public.actualizar_paquete(bigint, character varying, double precision) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 95373)
-- Name: actualizar_presupuesto(bigint, character varying, double precision, double precision, bigint, integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION actualizar_presupuesto(id bigint, descripcion character varying, peso double precision, precio double precision, id_presupuestador bigint, id_partida integer, id_destino integer, id_fragilidad integer, id_prioridad integer, direccion character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	UPDATE presupuesto
	SET precio=$3, peso=$3, descripcion=$2, id_presupuestador=$5, id_partida=$6, id_destino=$7, id_fragilidad=$8, id_prioridad=$9, direccion=$10
	WHERE presupuesto.id=$1;
END;
$_$;


ALTER FUNCTION public.actualizar_presupuesto(id bigint, descripcion character varying, peso double precision, precio double precision, id_presupuestador bigint, id_partida integer, id_destino integer, id_fragilidad integer, id_prioridad integer, direccion character varying) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 95374)
-- Name: checkloginuser(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION checkloginuser(_username character varying, _password character varying) RETURNS TABLE(nombres character varying, apellido_paterno character varying, apellido_materno character varying, numero_documento character varying, tipo_documento character varying, telefono character varying, correo_electronico character varying, nombre_usuario character varying, id_usuario bigint, id_persona bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT persona.nombres, persona.apellido_paterno, persona.apellido_materno, persona.numero_documento,
	persona.tipo_documento, persona.telefono, persona.correo_electronico, usuario.nombre_usuario,
	usuario.id as id_usuario, persona.id as id_persona
	FROM usuario 
	INNER JOIN persona
	ON persona.id_usuario=usuario.id
	WHERE usuario.nombre_usuario=_username AND usuario."contraseña"=_password;
END;
$$;


ALTER FUNCTION public.checkloginuser(_username character varying, _password character varying) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 95375)
-- Name: ciudades_de_reparto(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ciudades_de_reparto() RETURNS TABLE(id integer, nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT cr.id, cr.nombre
	FROM ciudades_de_reparto as cr
	ORDER BY cr.nombre, cr.id;
END
$$;


ALTER FUNCTION public.ciudades_de_reparto() OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 95419)
-- Name: clientes(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION clientes(integer) RETURNS TABLE(id bigint, nombres text, correo_electronico character varying, telefono character varying, numero_envios bigint)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY
	SELECT cliente.id, (persona.nombres || ' ' || persona.apellido_paterno || ' ' || persona.apellido_materno) as nombres,
	persona.correo_electronico, persona.telefono, cliente.numero_envios
	FROM cliente
	INNER JOIN persona
	ON cliente.id_persona = persona.id
	ORDER BY cliente.id
	LIMIT 25
	OFFSET $1;
	
END
$_$;


ALTER FUNCTION public.clientes(integer) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 95377)
-- Name: crear_entrega(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_entrega(bigint, bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	INSERT INTO entrega (id_presupuesto, id_cliente) VALUES($1,$2);
END
$_$;


ALTER FUNCTION public.crear_entrega(bigint, bigint) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 95378)
-- Name: eliminar_entrega(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION eliminar_entrega(bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	DELETE FROM entrega WHERE entrega.id=$1;
END
$_$;


ALTER FUNCTION public.eliminar_entrega(bigint) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 95379)
-- Name: eliminar_paquete(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION eliminar_paquete(bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	DELETE FROM paquete WHERE paquete.id=$1;
END
$_$;


ALTER FUNCTION public.eliminar_paquete(bigint) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 95380)
-- Name: eliminar_presupuesto(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION eliminar_presupuesto(bigint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	DELETE FROM presupuesto WHERE id=$1;
END;
$_$;


ALTER FUNCTION public.eliminar_presupuesto(bigint) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 95381)
-- Name: entregas(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION entregas(integer) RETURNS TABLE(id bigint, nombre_de_cliente text, descripcion character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY
	SELECT entrega.id, (persona.nombres || ' ' || persona.apellido_paterno || ' ' || persona.apellido_materno) as nombre_de_cliente, presupuesto.descripcion
	FROM presupuesto
	INNER JOIN entrega
	ON entrega.id_presupuesto = presupuesto.id
	INNER JOIN cliente
	ON entrega.id_cliente= cliente.id
	INNER JOIN persona
	ON persona.id=cliente.id_persona
	ORDER BY entrega.id DESC
	LIMIT 15
	OFFSET $1;
END
$_$;


ALTER FUNCTION public.entregas(integer) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 95382)
-- Name: fragilidad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fragilidad() RETURNS TABLE(id integer, nombre character varying, indice_fragilidad double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT fr.id, fr.nombre, fr.indice_fragilidad
	FROM fragilidad as fr
	ORDER BY fr.id;
END
$$;


ALTER FUNCTION public.fragilidad() OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 95383)
-- Name: getusers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getusers() RETURNS TABLE(nombre_usuario character varying, nombres character varying, apellido_paterno character varying, apellido_materno character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT usuario.nombre_usuario, persona.nombres, persona.apellido_paterno, persona.apellido_materno
	FROM usuario
	INNER JOIN persona
	ON usuario.id=persona.id_usuario
-- 	WHERE persona.nombres LIKE '%'||nombre_p||'%'
	ORDER BY usuario.nombre_usuario ASC;
END;
$$;


ALTER FUNCTION public.getusers() OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 95384)
-- Name: guardar_paquete(bigint, character varying, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION guardar_paquete(id_entrega bigint, descripcion character varying, peso double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	INSERT INTO paquete(id_entrega, descripcion, peso)
	VALUES ( $1, $2, $3);

END;
$_$;


ALTER FUNCTION public.guardar_paquete(id_entrega bigint, descripcion character varying, peso double precision) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 95385)
-- Name: guardar_presupuesto(character varying, double precision, double precision, bigint, integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION guardar_presupuesto(descripcion character varying, peso double precision, precio double precision, id_presupuestador bigint, id_partida integer, id_destino integer, id_fragilidad integer, id_prioridad integer, direccion character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
	INSERT INTO presupuesto(precio, peso, descripcion, fecha, id_presupuestador, id_partida, id_destino, id_fragilidad, id_prioridad, direccion)
	VALUES ( $3, $2, $1, now(), $4, $5, $6, $7, $8, $9);
END;
$_$;


ALTER FUNCTION public.guardar_presupuesto(descripcion character varying, peso double precision, precio double precision, id_presupuestador bigint, id_partida integer, id_destino integer, id_fragilidad integer, id_prioridad integer, direccion character varying) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 95084)
-- Name: historial_persona(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION historial_persona() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
	
	insert into "tabla_cambio_apellido"(ap_ant, ap_nuevo) --caso matrimonio
	values(Old.apellido_materno, new.apellido_materno);
	return old;
end;
$$;


ALTER FUNCTION public.historial_persona() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 95087)
-- Name: modificacion_vehiculo(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificacion_vehiculo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 INSERT INTO registro_modificacion_vehiculo(matricula, marca, modelo)
 VALUES(OLD.matricula, OLD.marca ,OLD.modelo);
 RETURN OLD;
END;
$$;


ALTER FUNCTION public.modificacion_vehiculo() OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 95389)
-- Name: obtener_entrega(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_entrega(bigint) RETURNS TABLE(id bigint, id_presupuesto bigint, id_cliente bigint)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY 
	SELECT entrega.id, entrega.id_presupuesto, entrega.id_cliente
	FROM entrega
	WHERE entrega.id = $1;
END
$_$;


ALTER FUNCTION public.obtener_entrega(bigint) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 95390)
-- Name: obtener_paquete(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_paquete(bigint) RETURNS TABLE(id bigint, descripcion character varying, peso double precision, id_entrega bigint)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY 
	SELECT paquete.id, paquete.descripcion, paquete.peso, paquete.id_entrega
	FROM paquete
	WHERE paquete.id = $1;
END
$_$;


ALTER FUNCTION public.obtener_paquete(bigint) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 95391)
-- Name: obtener_presupuesto(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_presupuesto(bigint) RETURNS TABLE(id bigint, descripcion character varying, fecha timestamp with time zone, precio double precision, peso double precision, direccion character varying, id_partida integer, id_destino integer, id_fragilidad integer, id_prioridad integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY
	SELECT presupuesto.id, presupuesto.descripcion, presupuesto.fecha, presupuesto.precio, presupuesto.peso,
		presupuesto.direccion, presupuesto.id_partida, presupuesto.id_destino, presupuesto.id_fragilidad,presupuesto.id_prioridad
	FROM prespupuestador
	LEFT JOIN trabajador
	ON prespupuestador.id_trabajador = trabajador.id
	INNER JOIN persona
	ON trabajador.id_persona=persona.id
	INNER JOIN usuario
	ON usuario.id = persona.id_usuario
	INNER JOIN presupuesto
	ON presupuesto.id_presupuestador = prespupuestador.id
	WHERE presupuesto.id = $1;
END;
$_$;


ALTER FUNCTION public.obtener_presupuesto(bigint) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 95392)
-- Name: paquetes_por_entrega(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION paquetes_por_entrega(bigint) RETURNS TABLE(id bigint, descripcion character varying, peso double precision)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY
	SELECT paquete.id, paquete.descripcion, paquete.peso
	FROM paquete
	WHERE paquete.id_entrega = $1
	ORDER BY paquete.descripcion;
END
$_$;


ALTER FUNCTION public.paquetes_por_entrega(bigint) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 95393)
-- Name: presupuestador_by_user(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION presupuestador_by_user(id bigint) RETURNS TABLE(id_presupuestador bigint, id_trabajador bigint)
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN QUERY
	SELECT prespupuestador.id, prespupuestador.id_trabajador 
	FROM usuario 
	INNER JOIN persona
	ON persona.id_usuario=usuario.id
	INNER JOIN trabajador
	ON trabajador.id_persona = persona.id
	INNER JOIN prespupuestador
	ON prespupuestador.id_trabajador = trabajador.id
	WHERE usuario.id=$1;
END;
$_$;


ALTER FUNCTION public.presupuestador_by_user(id bigint) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 95418)
-- Name: presupuestos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION presupuestos() RETURNS TABLE(id bigint, descripcion character varying, fecha timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT presupuesto.id, presupuesto.descripcion, presupuesto.fecha
	FROM presupuesto
	ORDER BY presupuesto.id ASC;
END;
$$;


ALTER FUNCTION public.presupuestos() OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 95394)
-- Name: presupuestos_por_nombre_usuario(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION presupuestos_por_nombre_usuario(nombre_usuario_p character varying) RETURNS TABLE(id bigint, descripcion character varying, precio double precision, peso double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT presupuesto.id, presupuesto.descripcion, presupuesto.precio, presupuesto.peso
	FROM prespupuestador
	LEFT JOIN trabajador
	ON prespupuestador.id_trabajador = trabajador.id
	INNER JOIN persona
	ON trabajador.id_persona=persona.id
	INNER JOIN usuario
	ON usuario.id = persona.id_usuario
	INNER JOIN presupuesto
	ON presupuesto.id_trabajador = trabajador.id
	WHERE usuario.nombre_usuario= nombre_usuario_p
	ORDER BY id, descripcion DESC;
END;
$$;


ALTER FUNCTION public.presupuestos_por_nombre_usuario(nombre_usuario_p character varying) OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 95395)
-- Name: presupuestos_por_presupuestador(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION presupuestos_por_presupuestador(nombres_p character varying, apellido_paterno_p character varying, apellido_materno_p character varying) RETURNS TABLE(nombres character varying, apellido_paterno character varying, apellido_materno character varying, descripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT persona.nombres, persona.apellido_paterno, persona.apellido_materno, presupuesto.descripcion
	FROM prespupuestador
	LEFT JOIN trabajador
	ON prespupuestador.id_trabajador = trabajador.id
	INNER JOIN persona
	ON trabajador.id_persona=persona.id
	INNER JOIN presupuesto
	ON presupuesto.id_trabajador = trabajador.id
	WHERE (persona.nombres || ' ' || persona.apellido_paterno || ' ' || persona.apellido_materno) LIKE '%' ||nombres_p || '%' 
	
	ORDER BY descripcion, persona.nombres ASC;
END;
$$;


ALTER FUNCTION public.presupuestos_por_presupuestador(nombres_p character varying, apellido_paterno_p character varying, apellido_materno_p character varying) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 95396)
-- Name: presupuestos_por_usuario(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION presupuestos_por_usuario(nombre_usuario_p character varying) RETURNS TABLE(id bigint, descripcion character varying, fecha timestamp with time zone, precio double precision, peso double precision, id_partida integer, id_destino integer, id_fragilidad integer, id_prioridad integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT presupuesto.id, presupuesto.descripcion, presupuesto.fecha, presupuesto.precio, presupuesto.peso, presupuesto.id_partida, presupuesto.id_destino, presupuesto.id_fragilidad, presupuesto.id_prioridad
	FROM prespupuestador
	LEFT JOIN trabajador
	ON prespupuestador.id_trabajador = trabajador.id
	INNER JOIN persona
	ON trabajador.id_persona=persona.id
	INNER JOIN usuario
	ON usuario.id = persona.id_usuario
	INNER JOIN presupuesto
	ON presupuesto.id_presupuestador = prespupuestador.id
	WHERE usuario.nombre_usuario= nombre_usuario_p
	ORDER BY fecha DESC;
END;
$$;


ALTER FUNCTION public.presupuestos_por_usuario(nombre_usuario_p character varying) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 95397)
-- Name: prioridad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION prioridad() RETURNS TABLE(id integer, nombre character varying, indice_prioridad double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY 
	SELECT pr.id, pr.nombre, pr.indice_prioridad
	FROM prioridad as pr
	ORDER BY pr.id;
END
$$;


ALTER FUNCTION public.prioridad() OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 95101)
-- Name: carga_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE carga_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE carga_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 95103)
-- Name: carga; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE carga (
    id bigint DEFAULT nextval('carga_id_seq'::regclass) NOT NULL,
    fecha_partida timestamp with time zone,
    fecha_llegada timestamp with time zone,
    id_chofer bigint,
    detalles character varying
);


ALTER TABLE carga OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 95110)
-- Name: chofer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE chofer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE chofer_id_seq OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 95112)
-- Name: chofer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE chofer (
    id bigint DEFAULT nextval('chofer_id_seq'::regclass) NOT NULL,
    id_trabajador bigint,
    id_vehiculo bigint
);


ALTER TABLE chofer OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 95116)
-- Name: ciudades_de_reparto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ciudades_de_reparto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ciudades_de_reparto_id_seq OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 95118)
-- Name: ciudades_de_reparto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ciudades_de_reparto (
    id integer DEFAULT nextval('ciudades_de_reparto_id_seq'::regclass) NOT NULL,
    nombre character varying
);


ALTER TABLE ciudades_de_reparto OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 95125)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cliente_id_seq OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 95127)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cliente (
    id bigint DEFAULT nextval('cliente_id_seq'::regclass) NOT NULL,
    numero_envios bigint,
    id_persona bigint
);


ALTER TABLE cliente OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 95131)
-- Name: entrega_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE entrega_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE entrega_id_seq OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 95133)
-- Name: entrega; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE entrega (
    id bigint DEFAULT nextval('entrega_id_seq'::regclass) NOT NULL,
    id_presupuesto bigint,
    id_cliente bigint
);


ALTER TABLE entrega OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 95137)
-- Name: fragilidad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fragilidad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fragilidad_id_seq OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 95139)
-- Name: fragilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE fragilidad (
    id integer DEFAULT nextval('fragilidad_id_seq'::regclass) NOT NULL,
    nombre character varying,
    indice_fragilidad double precision
);


ALTER TABLE fragilidad OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 95146)
-- Name: historial_quejas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE historial_quejas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE historial_quejas_id_seq OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 95148)
-- Name: historial_quejas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE historial_quejas (
    id bigint DEFAULT nextval('historial_quejas_id_seq'::regclass) NOT NULL,
    id_usuario bigint,
    fecha timestamp with time zone,
    descripcion character varying
);


ALTER TABLE historial_quejas OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 95155)
-- Name: paquete_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE paquete_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE paquete_id_seq OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 95157)
-- Name: paquete; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE paquete (
    id bigint DEFAULT nextval('paquete_id_seq'::regclass) NOT NULL,
    id_entrega bigint,
    descripcion character varying,
    id_carga bigint,
    peso double precision
);


ALTER TABLE paquete OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 95164)
-- Name: persona_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE persona_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE persona_id_seq OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 95166)
-- Name: persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE persona (
    id bigint DEFAULT nextval('persona_id_seq'::regclass) NOT NULL,
    nombres character varying,
    apellido_paterno character varying,
    apellido_materno character varying,
    numero_documento character varying,
    tipo_documento character varying,
    telefono character varying,
    correo_electronico character varying,
    id_usuario bigint
);


ALTER TABLE persona OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 95173)
-- Name: prespupuestador_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prespupuestador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prespupuestador_id_seq OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 95175)
-- Name: prespupuestador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE prespupuestador (
    id bigint DEFAULT nextval('prespupuestador_id_seq'::regclass) NOT NULL,
    id_trabajador bigint
);


ALTER TABLE prespupuestador OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 95179)
-- Name: presupuesto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE presupuesto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE presupuesto_id_seq OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 95181)
-- Name: presupuesto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE presupuesto (
    id bigint DEFAULT nextval('presupuesto_id_seq'::regclass) NOT NULL,
    id_presupuestador bigint,
    id_partida integer,
    id_destino integer,
    precio double precision,
    peso double precision,
    id_fragilidad integer,
    id_prioridad integer,
    direccion character varying,
    descripcion character varying DEFAULT 'asd'::character varying,
    fecha timestamp with time zone
);


ALTER TABLE presupuesto OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 95189)
-- Name: prioridad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE prioridad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prioridad_id_seq OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 95191)
-- Name: prioridad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE prioridad (
    id integer DEFAULT nextval('prioridad_id_seq'::regclass) NOT NULL,
    nombre character varying,
    indice_prioridad double precision
);


ALTER TABLE prioridad OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 95198)
-- Name: registro_modificacion_vehiculo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE registro_modificacion_vehiculo (
    id integer NOT NULL,
    matricula character varying,
    marca character varying,
    modelo character varying
);


ALTER TABLE registro_modificacion_vehiculo OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 95204)
-- Name: registro_modificacion_vehiculo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE registro_modificacion_vehiculo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE registro_modificacion_vehiculo_id_seq OWNER TO postgres;

--
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 206
-- Name: registro_modificacion_vehiculo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE registro_modificacion_vehiculo_id_seq OWNED BY registro_modificacion_vehiculo.id;


--
-- TOC entry 207 (class 1259 OID 95206)
-- Name: tabPrueba; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "tabPrueba" (
    nombres character varying,
    apellido character varying,
    edad character varying,
    id integer NOT NULL
);


ALTER TABLE "tabPrueba" OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 95212)
-- Name: tabPrueba_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE "tabPrueba_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "tabPrueba_id_seq" OWNER TO postgres;

--
-- TOC entry 2431 (class 0 OID 0)
-- Dependencies: 208
-- Name: tabPrueba_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE "tabPrueba_id_seq" OWNED BY "tabPrueba".id;


--
-- TOC entry 209 (class 1259 OID 95214)
-- Name: tabla_cambio_apellido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tabla_cambio_apellido (
    ap_ant character varying,
    ap_nuevo character varying,
    id integer NOT NULL
);


ALTER TABLE tabla_cambio_apellido OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 95220)
-- Name: tabla_cambio_apellido_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tabla_cambio_apellido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tabla_cambio_apellido_id_seq OWNER TO postgres;

--
-- TOC entry 2432 (class 0 OID 0)
-- Dependencies: 210
-- Name: tabla_cambio_apellido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE tabla_cambio_apellido_id_seq OWNED BY tabla_cambio_apellido.id;


--
-- TOC entry 211 (class 1259 OID 95222)
-- Name: trabajador_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE trabajador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE trabajador_id_seq OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 95224)
-- Name: trabajador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trabajador (
    id bigint DEFAULT nextval('trabajador_id_seq'::regclass) NOT NULL,
    fecha_contratacion timestamp with time zone,
    id_persona bigint
);


ALTER TABLE trabajador OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 95228)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuario_id_seq OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 95230)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuario (
    id bigint DEFAULT nextval('usuario_id_seq'::regclass) NOT NULL,
    nombre_usuario character varying,
    "contraseña" character varying
);


ALTER TABLE usuario OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 95237)
-- Name: vehiculo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vehiculo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vehiculo_id_seq OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 95239)
-- Name: vehiculo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vehiculo (
    id bigint DEFAULT nextval('vehiculo_id_seq'::regclass) NOT NULL,
    matricula character varying,
    marca character varying,
    modelo character varying
);


ALTER TABLE vehiculo OWNER TO postgres;

--
-- TOC entry 2214 (class 2604 OID 95246)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registro_modificacion_vehiculo ALTER COLUMN id SET DEFAULT nextval('registro_modificacion_vehiculo_id_seq'::regclass);


--
-- TOC entry 2215 (class 2604 OID 95247)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "tabPrueba" ALTER COLUMN id SET DEFAULT nextval('"tabPrueba_id_seq"'::regclass);


--
-- TOC entry 2216 (class 2604 OID 95248)
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tabla_cambio_apellido ALTER COLUMN id SET DEFAULT nextval('tabla_cambio_apellido_id_seq'::regclass);


--
-- TOC entry 2387 (class 0 OID 95103)
-- Dependencies: 182
-- Data for Name: carga; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (1, '2016-09-16 00:00:00-05', '2016-09-17 00:00:00-05', 2, '4 cajas');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (2, '2016-09-16 00:00:00-05', '2016-09-17 00:00:00-05', 5, '2 cajas');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (3, '2016-09-14 00:00:00-05', '2016-09-15 00:00:00-05', 3, '1 caja');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (4, '2016-09-15 00:00:00-05', '2016-09-16 00:00:00-05', 6, '1 caja');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (5, '2016-09-16 00:00:00-05', '2016-09-18 00:00:00-05', 10, '1 caja');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (6, '2016-09-12 00:00:00-05', '2016-09-13 00:00:00-05', 1, '2 cajas');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (7, '2016-09-12 00:00:00-05', '2016-09-13 00:00:00-05', 2, '1 caja');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (8, '2016-09-02 00:00:00-05', '2016-09-03 00:00:00-05', 7, '2 cajas');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (9, '2016-09-06 00:00:00-05', '2016-09-07 00:00:00-05', 4, '1 caja');
INSERT INTO carga (id, fecha_partida, fecha_llegada, id_chofer, detalles) VALUES (10, '2016-09-16 00:00:00-05', '2016-09-17 00:00:00-05', 8, '1 caja');


--
-- TOC entry 2433 (class 0 OID 0)
-- Dependencies: 181
-- Name: carga_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('carga_id_seq', 10, true);


--
-- TOC entry 2389 (class 0 OID 95112)
-- Dependencies: 184
-- Data for Name: chofer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (1, 11, 8);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (2, 12, 10);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (3, 13, 4);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (4, 14, 6);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (5, 15, 1);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (6, 16, 2);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (7, 17, 3);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (8, 18, 7);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (9, 19, 9);
INSERT INTO chofer (id, id_trabajador, id_vehiculo) VALUES (10, 20, 5);


--
-- TOC entry 2434 (class 0 OID 0)
-- Dependencies: 183
-- Name: chofer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('chofer_id_seq', 10, true);


--
-- TOC entry 2391 (class 0 OID 95118)
-- Dependencies: 186
-- Data for Name: ciudades_de_reparto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO ciudades_de_reparto (id, nombre) VALUES (1, 'Arequipa');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (2, 'Lima');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (3, 'Ica');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (4, 'Tacna');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (5, 'Cusco');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (6, 'Puno');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (7, 'Tumbes');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (8, 'Piura');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (9, 'La Libertad');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (10, 'Pasco');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (11, 'Huancavelica');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (12, 'Apurímac');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (13, 'Lambayeque');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (14, 'BAGUA GRANDE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (15, 'CHACHAPOYAS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (16, 'CHIMBOTE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (17, 'HUARAZ');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (18, 'CASMA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (19, 'ABANCAY');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (20, 'ANDAHUAYLAS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (21, 'CAMANÁ');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (22, 'ISLAY');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (23, 'AYACUCHO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (24, 'HUANTA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (25, 'CAJAMARCA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (26, 'JAÉN');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (27, 'CANCHIS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (28, 'LA CONVENCIÓN');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (29, 'YAURI (ESPINAR)');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (30, 'HUÁNUCO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (31, 'LEONCIO PRADO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (32, 'CHINCHA ALTA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (33, 'PISCO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (34, 'NAZCA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (35, 'HUANCAYO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (36, 'TARMA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (37, 'LA OROYA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (38, 'JAUJA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (39, 'TRUJILLO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (40, 'CHEPÉN');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (41, 'GUADALUPE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (42, 'CASA GRANDE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (43, 'PACASMAYO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (44, 'HUAMACHUCO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (45, 'LAREDO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (46, 'MOCHE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (47, 'CHICLAYO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (48, 'FERREÑAFE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (49, 'TUMAN');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (50, 'MONSEFU');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (51, 'LIMA METROPOLITANA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (52, 'HUACHO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (53, 'HUARAL');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (54, 'SAN VICENTE DE CAÑETE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (55, 'BARRANCA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (56, 'HUAURA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (57, 'PARAMONGA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (58, 'CHANCAY');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (59, 'MALA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (60, 'SUPE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (61, 'IQUITOS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (62, 'YURIMAGUAS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (63, 'PUERTO MALDONADO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (64, 'ILO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (65, 'MOQUEGUA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (66, 'SULLANA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (67, 'TALARA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (68, 'CATACAOS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (69, 'PAITA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (70, 'CHULUCANAS');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (71, 'SECHURA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (72, 'JULIACA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (73, 'AYAVIRI');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (74, 'ILAVE');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (75, 'TARAPOTO');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (76, 'MOYOBAMBA');
INSERT INTO ciudades_de_reparto (id, nombre) VALUES (77, 'PUCALLPA');


--
-- TOC entry 2435 (class 0 OID 0)
-- Dependencies: 185
-- Name: ciudades_de_reparto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ciudades_de_reparto_id_seq', 77, true);


--
-- TOC entry 2393 (class 0 OID 95127)
-- Dependencies: 188
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO cliente (id, numero_envios, id_persona) VALUES (1, 5, 11);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (2, 1, 12);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (3, 2, 13);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (4, 2, 14);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (5, 1, 15);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (6, 3, 16);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (7, 8, 17);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (8, 2, 18);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (9, 1, 19);
INSERT INTO cliente (id, numero_envios, id_persona) VALUES (10, 3, 20);


--
-- TOC entry 2436 (class 0 OID 0)
-- Dependencies: 187
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cliente_id_seq', 10, true);


--
-- TOC entry 2395 (class 0 OID 95133)
-- Dependencies: 190
-- Data for Name: entrega; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (1, 1, 3);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (2, 2, 1);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (3, 3, 3);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (4, 4, 2);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (5, 5, 9);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (6, 6, 6);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (7, 7, 8);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (8, 8, 2);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (9, 9, 5);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (10, 33, 4);
INSERT INTO entrega (id, id_presupuesto, id_cliente) VALUES (11, 102, 10);


--
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 189
-- Name: entrega_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('entrega_id_seq', 11, true);


--
-- TOC entry 2397 (class 0 OID 95139)
-- Dependencies: 192
-- Data for Name: fragilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO fragilidad (id, nombre, indice_fragilidad) VALUES (3, 'Fragil', 3);
INSERT INTO fragilidad (id, nombre, indice_fragilidad) VALUES (4, 'Muy frágil', 4);
INSERT INTO fragilidad (id, nombre, indice_fragilidad) VALUES (1, 'No Fragil', 0.900000000000000022);
INSERT INTO fragilidad (id, nombre, indice_fragilidad) VALUES (2, 'Normlal', 1);


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 191
-- Name: fragilidad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('fragilidad_id_seq', 4, true);


--
-- TOC entry 2399 (class 0 OID 95148)
-- Dependencies: 194
-- Data for Name: historial_quejas; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (2, 4, '2016-06-12 00:00:00-05', 'Malos tratos en ventanilla');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (8, 10, '2016-09-03 00:00:00-05', 'Apertura tarde del local');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (9, 2, '2016-09-20 00:00:00-05', 'Entrega de paquetería en mal estado');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (11, 17, '2016-05-23 00:00:00-05', 'Apertura tarde del local');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (13, 18, '2016-05-23 00:00:00-05', 'Apertura tarde del local');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (14, 12, '2016-03-12 00:00:00-05', 'Malos tratos en ventanilla');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (15, 11, '2015-03-22 00:00:00-05', 'Cobros indebidos ');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (16, 15, '2010-05-30 00:00:00-05', 'Cobros indebidos');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (17, 10, '2014-05-23 00:00:00-05', 'mal comportamiento de conductores');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (18, 6, '2012-04-01 00:00:00-05', 'mal comportamiento de conductores');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (19, 1, '2014-05-30 00:00:00-05', 'mal comportamiento de conductores');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (20, 1, '2015-11-21 00:00:00-05', 'apertura tarde del local');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (1, 2, '2015-05-10 00:00:00-05', 'Malos tratos en ventanilla');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (3, 7, '2014-06-20 00:00:00-05', 'Alega cobros extras al momento de recojo');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (4, 9, '2014-07-22 00:00:00-05', 'Alega entrega de paquete en mal estado');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (5, 3, '2014-09-20 00:00:00-05', 'Demora en el envío');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (6, 1, '2013-09-20 00:00:00-05', 'Mal comportamiento del personal de servicio');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (7, 1, '2015-09-20 00:00:00-05', 'Quejas sobre cobros indebidos');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (10, 5, '2014-05-23 00:00:00-05', 'Malos tratos en ventanilla');
INSERT INTO historial_quejas (id, id_usuario, fecha, descripcion) VALUES (12, 17, '2016-05-24 00:00:00-05', 'Apertura tarde del local');


--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 193
-- Name: historial_quejas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('historial_quejas_id_seq', 9, true);


--
-- TOC entry 2401 (class 0 OID 95157)
-- Dependencies: 196
-- Data for Name: paquete; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (1, 1, 'mouse', 3, 1);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (2, 2, 'unique perfume', 3, 1.5);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (3, 3, 'maquina soldadura', 2, 6.59999999999999964);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (4, 4, 'vajilla', 2, 8);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (5, 5, 'mochila', 1, 2);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (6, 6, 'laptop', 5, 3.60000000000000009);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (7, 7, 'sofa', 5, 35.7000000000000028);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (8, 8, 'equipo de sonid', 5, 15);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (9, 9, 'botiquin', 5, 4);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (10, 10, 'gorra de beisbol', 9, 2.79999999999999982);
INSERT INTO paquete (id, id_entrega, descripcion, id_carga, peso) VALUES (12, 11, 'paquete pequeño de cosas mas fragiles', NULL, 13);


--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 195
-- Name: paquete_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('paquete_id_seq', 12, true);


--
-- TOC entry 2403 (class 0 OID 95166)
-- Dependencies: 198
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (3, 'Dennis ', 'Pumaraime', 'Mendoza', '23456789', 'dni', '234567890', 'dennis.puma@gmail.com', 4);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (4, 'Piter Javier', 'Dueñas', 'Lopez', '34567890', 'dni', '345678901', 'piter.dueñas@gmail.com', 5);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (5, 'Marcos', 'Pinto', 'Arellanos', '45678901', 'dni', '456789012', 'marcos.pinto@gmail.com', 6);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (6, 'Jorge Enquique', 'Basadre', 'Rondoy', '56789012', 'dni', '567890123', 'jorge.basadre@gmail.com', 7);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (7, 'Mike', 'Miller', 'Solis', '67890123', 'dni', '678901234', 'mike.miller@gmail.com', 8);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (8, 'Nelson', 'Arendegui', 'Alcala', '78901234', 'dni', '789012345', 'nelson.arendegui@gmail.com', 9);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (9, 'Luna', 'Bravo', 'Villegas', '89012345', 'dni', '890123456', 'luna.villegas@gmail.com', 10);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (10, 'Enrique', 'Peña', 'Villegas', '90123456', 'dni', '901234567', 'enrique.peña@gmail.com', 1);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (11, 'raul', 'sucre', 'sucre', '12345678', 'DNI', '988484', 'asdasd@gmnal.com', 11);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (12, 'bueno', 'mesa', 'mesa', '3737377', 'DNI', '83838388', 'bueno@gmail.com', 12);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (13, 'joel', 'ccari', 'ccari', '383838388', 'DNI', '833388383', 'joel@gamil.com', 13);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (14, 'joel', 'bueno', 'bueno', '383838838', 'DNI', '2822288', 'ccari@gmail.com', 14);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (15, 'raul', 'valdivia', 'vladi', '38383881', 'DNI', '88918393', 'valdivia@gmailcom', 15);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (16, 'jorge', 'lagos', 'lagos', '3768138', 'DNI', '129910', 'lagos@hotmail.com', 16);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (17, 'manuel', 'manrique', 'manrique', '192109090', 'DNI', '7773711', 'mmanrique@yahoo.es', 17);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (18, 'daniel', 'benavente', 'benavente', '12383921', 'PASAPORTE', '213213', 'dbena@yahoo.com', 18);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (20, 'oscar', 'tejado', 'lana', '12849493', 'DNI', '1234312', 'otejado@gmail.com', 20);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (19, 'dennis', 'bueno', 'bueno', '82383881', 'PASAPORTE', '123456', 'denmalo@hotmail.com', 19);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (21, 'marcelo', 'roque', 'roque', '89876473', 'DNI', '9845855', 'mroque@gmail.com', 21);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (22, 'javier', 'wong', 'wong', '98454541', 'DNI', '9848424', 'jwong@gmail.com', 22);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (23, 'maribel', 'yana', 'yana', '424884841GG', 'PASAPORTE', '984948', 'myana@gmail.com', 23);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (24, 'carl', 'weisn', NULL, '473298874KLM', 'PASAPORTE', '98949494', 'cweisn@yahoo.com', 24);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (25, 'miguel', 'machaca', 'puma', '47321914', 'DNI', '94897811', 'mmachaca@gmail.com', 25);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (26, 'cesar', 'laura', 'laura', '3787387873', 'DNI', '3737377', 'claura@gmail.com', 26);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (27, 'raul', 'malaga', 'peres', '37737377', 'PASAPORTE', '273737', 'rmalaga@gmail.com', 27);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (28, 'oscar', 'reyes', 'marques', '3737737', 'DNI', '37373773', 'oreyes@gmail.com', 28);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (29, 'joe', 'ballon', 'rivera', '8786464', 'PASAPORTE', '8857757', 'jballon@hotmail.com', 29);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (30, 'alonso', 'castro', 'altamiran', '3717366', 'DNI', '8187421', 'alonso.castro@yahoo.es', 30);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (1, 'Jhoel ', 'Ccari', 'Quispe', '73120716', 'dni', '992238171', 'jhoel.ccari@gmail.com', 2);
INSERT INTO persona (id, nombres, apellido_paterno, apellido_materno, numero_documento, tipo_documento, telefono, correo_electronico, id_usuario) VALUES (2, 'Oscar ', 'Luza', 'Gomez', '12345678', 'dni', '123456789', 'oscar.luza@gmail.com', 3);


--
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 197
-- Name: persona_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('persona_id_seq', 30, true);


--
-- TOC entry 2405 (class 0 OID 95175)
-- Dependencies: 200
-- Data for Name: prespupuestador; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO prespupuestador (id, id_trabajador) VALUES (1, 1);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (2, 2);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (3, 3);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (4, 4);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (5, 5);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (6, 6);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (7, 7);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (8, 8);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (9, 9);
INSERT INTO prespupuestador (id, id_trabajador) VALUES (10, 10);


--
-- TOC entry 2442 (class 0 OID 0)
-- Dependencies: 199
-- Name: prespupuestador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('prespupuestador_id_seq', 10, true);


--
-- TOC entry 2407 (class 0 OID 95181)
-- Dependencies: 202
-- Data for Name: presupuesto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (30, 3, 8, 4, 335.028617400676012, 622.528987228870392, 3, 1, 'Jiron North Clifton 268', 'Envio de: DESARMADOR TRUPER DG-1/8X6 PLANO T/CABIN, LONA 3C ROJA 27X50(8.20X15.00), LONA LIGERA AZUL 18X24 (5.40X7.20)', '2010-08-12 08:09:10.6272-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (31, 3, 8, 6, 558.896112013608217, 666.4120939001441, 2, 2, 'Avenida Ofallon 112', 'Envio de: CONECTOR CPVC 3/4CUERDA EXTERIOR, CABLE PASA CORRIENTE CAL.8 MAR-RAM 3.5MT, CAVADOR TRUPER MANGO DE ACERO 47 HERCUL', '2005-11-26 01:10:43.5648-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (32, 2, 1, 9, 431.041457448154688, 714.546418972313404, 2, 2, 'Pasaje Demerrit 5', 'Envio de: LLAVE MIXTA MM 11 SANTUL 7615, VALVULA DE FLOTADOR LATON 1/2 FOSET, BROCA JGO  4 PZS MAR-RAM 4X12 CONCRET', '2009-05-15 04:36:05.8464-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (33, 7, 2, 4, 322.04089755192399, 653.558938521891832, 3, 2, 'Prolongacion S University 631', 'Envio de: CLAVO P/CONCRETO GALVANIZADO 3 AKSI KILO, CONEXION TRUPER REM-1/2 MACHO P/MANGUER*, EXTEN. P/AUDIO 1P3.5A2PL RCA PLUG RCA NI', '2012-09-30 02:48:08.8704-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (34, 7, 3, 4, 209.222375173121691, 331.387302130460739, 2, 2, 'Avenida Newberry 774', 'Envio de: LIMA TRIANGULO DOBLE TRUPER LTD-6 *, FOCO E12 LED TIPO VELA AKSI LUZ CALID127, ELIMINADOR CARNU DE HUMEDAD Y OLOR 340GR', '2007-07-20 07:25:09.7248-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (35, 1, 10, 8, 890.222830455750227, 594.211430512368679, 3, 2, 'Avenida Arch Airport 602', 'Envio de: ESPATULA 3 M/PLASTICO KEER, LONA S AZUL 12X12(3.60X3.60), TAQUETE EXPANSION 1/2 X 3 1/2 *', '2005-09-13 00:38:03.0624-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (36, 1, 6, 3, 166.635218299925327, 587.300799079239368, 2, 1, 'Avenida Laud Honm 782', 'Envio de: PEGAMENTO PVC TUBO FOSET 50 G, LLAVE ESPA¥OLA 11/16 X 3/4 KNOVA, PICOLETA REFORZADA HACHA SUELA', '2009-12-13 04:13:43.4496-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (37, 9, 3, 8, 929.138374272733927, 947.330950517207384, 2, 2, 'Jiron Bent Fold 720', 'Envio de: APAGADOR SENCILLO FLUORE TOOLCRAFT, PLAFON REDONDO 32W TOOLCRAFT, SIL SELLADOR ACRILICO ACRYRUB BLANCO300M', '2012-02-23 17:45:12.3552-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (38, 7, 7, 3, 322.035847455263138, 275.703805722296238, 3, 1, 'Prolongacion Regency Forest 560', 'Envio de: CESPOL FLEXIBLE PARA FREGADERO PVC 1, PINZA SACA FUSIBLES TRUPER PIFU-7, SOCKET SENCILLO SAMMY *', '2011-04-07 19:39:20.5056-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (39, 5, 6, 8, 78.7216417863965034, 833.694361839443445, 1, 3, 'Jiron Blue Bonnet 859', 'Envio de: ARCO P/SEGUETA SOLERA 1/4X1  GRIS, LONA LIGERA AZUL 10X12 (3.00X3.60), NOVIOS DE BAJO DE ARCO FH49008E-C', '2009-02-17 16:05:11.616-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (40, 9, 2, 5, 548.093200419098139, 417.912969589233398, 3, 1, 'Prolongacion Grovefield 969', 'Envio de: MANGO TRUPER P/MARRO 4 LBS MG-MD-4 *, GANCHO P/CORTINA C/1000 PZ. *, COFLEX P/WC 50 CM FOSET ALUMINIO', '2011-10-18 08:02:06.6624-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (41, 2, 10, 3, 162.947360184043646, 988.043531533330679, 2, 3, 'Jiron Fallsbrook 1', 'Envio de: COPLE REDUCCION CAMAPANA 1X3/4 FOSET, LLAVE ESPA¥OLA MM  6X7 SANTUL 7771, RESISTOL LAPIZ ADHESIVO KOLE 8G', '2008-12-28 05:22:44.0832-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (42, 6, 2, 2, 857.698880825191736, 379.66174840927124, 1, 2, 'Pasaje Corens 347', 'Envio de: GRAPA ET-50-5/16 AKSI C/1000 PZS, CADENA PASEO 2    MAR-RAM, LLANTA P/DIABLO 10 SOLA LION       8267', '2005-03-06 16:59:39.696-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (43, 1, 4, 9, 861.611034478992224, 280.303899887949228, 1, 3, 'Pasaje Woods Landing 452', 'Envio de: LLAVE ESPA¥OLA 9/16X5/8 SANTUL 7655, PIEDRAS MONTADAS AKSI 10 PZS, CABLE NO.12 BLANCO IUSA', '2010-04-05 11:17:46.6944-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (44, 2, 8, 5, 753.340441025793552, 954.326144177466631, 3, 3, 'Pasaje North Sage 994', 'Envio de: CHIFLON SANTUL 3 1/2 P/MANG 1/2 BRONCE, FOCO AHORRADOR SPIRAL  15W KEER 1602, CANDADO MAR-RAM DORADO LL/LATERAL 40 MM', '2012-02-23 20:27:52.1856-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (45, 5, 9, 5, 537.825965080410242, 376.741296835243702, 3, 3, 'Avenida Saint Hillaire 142', 'Envio de: CLAVO SIN CABEZA 1 FIERO KILO, GRAPA C/REDONDO  6 MM NEGRO COAXIAL AKSI, ADAPTADOR TELEFONICO 2 A 1 VOLTECH', '2008-07-20 23:02:04.0704-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (46, 10, 8, 4, 404.538467284291983, 66.5473027527332306, 3, 2, 'Prolongacion Lake Windermere 200', 'Envio de: BOMBA DE MANO 20 MAR-RAM BP20MR, FOCO AHORRADOR SPIRAL   9W MINI AKSI L/D, CAJA PARA LLAVES HERMEX 60G 24X30X8CM', '2013-06-03 09:50:50.0352-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (47, 5, 5, 8, 571.459461692720652, 369.71201304346323, 1, 2, 'Jiron Beaver Meadow 451', 'Envio de: CHALECO DE SEGURIDAD PRETUL VERDE CINTAS, PALANCA P/WC CROMADA FOSET TRUP PW-019**, REDUCCION BUSH DE 1 1/4 A 1/2', '2008-08-29 07:26:55.9104-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (48, 10, 5, 10, 226.899358201771975, 411.380979456007481, 3, 2, 'Calle Loxford Hall  Loxford 779', 'Envio de: VOLTEADOR DE ALUMINIO C/MAG MADERA RA415, CARTUCHO P/ENC.CHICO *, CONTACTO SENCILLO ROYER SENC.3112 *', '2009-12-16 04:07:10.3296-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (49, 5, 4, 10, 674.634694810956717, 160.628082919865847, 1, 2, 'Avenida Stonny Batter 290', 'Envio de: LIJA ESMERIL GRANO  50 TRUPER NEG LIME-5, ELIMINADOR MITZU 1000 MA 7 CONECTORES, CANDADO PHILLIPS NO.6 G/CORTO.    B', '2012-10-13 22:25:10.5024-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (50, 7, 5, 4, 386.672148238867521, 741.324471533298492, 3, 3, 'Jiron Lastingham 777', 'Envio de: BROCA JGO  6 PZS MAR-RAM P/MADERA, BOTA HULE SANITARIA NO.29 SURTEK, GUANTE TRUPER NYLON POLIURETANO GRANDE', '2009-06-24 00:28:39.216-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (51, 2, 5, 7, 492.195390854030848, 762.446890342980623, 2, 3, 'Avenida Covell 360', 'Envio de: LLAVE P/GAS PRETUL 7/8 LL-GA-P *, BOTE INTEGRAL 10 CTM, LLAVE MIXTA PZS  5 EN  C', '2012-08-03 22:48:49.3632-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (52, 10, 2, 7, 132.951658442616463, 335.047610327601433, 1, 1, 'Pasaje Riche 512', 'Envio de: LINTERNA AKSI 1 + 12 LED LIGTH AZUL/GRIS, CARDA P/TALADRO 5 PZS SANTUL 8068, MANGO PARA HACHA *', '2011-12-12 17:34:05.6064-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (53, 9, 3, 8, 970.988386999815702, 207.31566309928894, 2, 3, 'Jiron Beninford 125', 'Envio de: EXTEN. P/TELEFONO PLANA 7.6 MTS SANELEC, PINZA PARA TIERRA REFORZADA, TIJERA P/ROSAS TRUPER T-66', '2005-01-31 13:52:33.3984-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (1, 4, 2, 3, 40, 1, 1, 1, 'Jr.Lima 102 Rastore', 'asd', '2016-09-16 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (2, 2, 10, 4, 55, 2, 4, 1, 'Av.Pumacahua 40-A San Isidro', 'asd', '2016-09-16 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (3, 1, 2, 5, 50, 1, 2, 1, 'Calle Arica 102 Bustamante', 'asd', '2016-09-14 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (4, 4, 2, 10, 40, 1, 1, 1, 'Gasper J. 100-B Urugato', 'asd', '2016-09-15 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (5, 9, 2, 10, 40, 3, 1, 1, 'Calle Lima 206 La Union Salvador', 'asd', '2016-09-16 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (6, 8, 5, 3, 50, 5, 4, 2, 'Calle Brasil 101 Santos', 'asd', '2016-09-12 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (7, 7, 6, 4, 30, 1, 4, 1, 'Calle Oros 45-B Juanes del Sur', 'asd', '2016-09-12 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (8, 10, 1, 6, 30, 20, 2, 1, 'Calle Arica 100 Israel ', 'asd', '2016-09-02 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (9, 3, 9, 8, 30, 10, 2, 1, 'Calle Roswell 404 Urb. Los Alamos Astore', 'asd', '2016-09-06 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (10, 5, 3, 7, 60, 1, 2, 3, 'Calle Marcopolo J. 1007 Jamaica', 'asd', '2016-09-16 00:00:00-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (54, 3, 4, 2, 498.849497865885496, 725.237320400774479, 2, 3, 'Avenida Longstomps 771', 'Envio de: ANTENA SANELEC GIRATORIA CLASICA CONTROL, NUDO P/CABLE 3/8 FIERO TRUPER, CABLE COAXIAL RG-6 100 MTS VOLTECH', '2008-12-27 06:18:50.4-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (55, 5, 8, 2, 842.15916994959116, 348.24619697406888, 3, 2, 'Pasaje Galton 796', 'Envio de: CADENA GALVANIZADA 5/16 POR METRO, MANERAL L MOR 3/4 *, CALEN. PORC.MEDIANO', '2014-03-15 09:02:31.92-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (56, 6, 1, 5, 442.941756676882505, 185.881658215075731, 2, 1, 'Jiron W Marshall 158', 'Envio de: BROCA JGO  5 PZS MAR-RAM METAL COBALTO, GUANTE SR LIMPIO MEDIANOS ROJOS, DIVISOR 2 SALIDAS VOLTECH', '2012-01-31 11:40:31.9872-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (57, 10, 1, 1, 347.448279373347759, 961.527330558747053, 2, 2, 'Avenida Vallecito 728', 'Envio de: CANDADO CHICOTE MAR-RAM LL/TUBULAR 15, LONA 3C AMARILLA 12X18(3.60X5.40), CESPOL P/FREGADERO FOSET SIN CONTRA', '2005-06-29 17:54:15.3792-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (58, 9, 7, 7, 599.855505619198084, 48.1707288324832916, 1, 3, 'Pasaje Deanwood 777', 'Envio de: REPARADOR TRUPER PARA MANGUERA 3/8 TRUPE, MEZCLADORA LAVABO 4 AKSI M/TIPO MARFIL, PINZA MINI 3 PZS MAR-RAM 4 1/2', '2012-12-12 17:17:37.536-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (59, 3, 5, 3, 472.667169980704784, 354.041349366307259, 1, 1, 'Jiron Pine Acres 209', 'Envio de: ESCUADRA ESQUINERA 2           ES61103, MEZCLADORA LAVABO 4 MAX-TOOLS C/T BA, ALAMBRE DE PUAS CALI 15 ROLLO DE 100MTSA', '2008-07-23 21:13:58.1952-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (60, 5, 5, 2, 447.608182430267334, 254.954949244856834, 1, 1, 'Prolongacion John Dailey 612', 'Envio de: PINTURA TRUPER METALICO COBRE 400 PAM-, ACIDO MURIATICO 1 LTS ., TIJERA TRUPER TICO-8 P/COSTURA 8 1/2 MA', '2006-03-25 10:41:03.84-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (61, 3, 9, 7, 269.941074065864086, 306.149667352437973, 3, 3, 'Jiron Spaulding 803', 'Envio de: GUANTE LION TOOLS NITRILO BLANCO GRANDE, SILICON BARRA CHICO POR KILO MAR-RAM., PALA CUADRADA TRUPER PROMO PCY-P', '2008-12-28 13:27:58.896-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (62, 8, 7, 3, 399.772483613342047, 911.727430056780577, 3, 1, 'Jiron N Clark 684', 'Envio de: CODO TERMOFLOW  3/4X90 CUERDA MACHO, TAQUETE PLASTICO 5/16 ALPHA CAJA, LONA S GRIS 16X20(4.80X6.00) MED AL CORT', '2007-07-09 20:23:35.4048-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (63, 8, 5, 4, 867.628972735255957, 20.1419007405638695, 2, 3, 'Pasaje Arthur 509', 'Envio de: SOLDADURA P/GAS POR METRO 95/5 **OJO****, BANDOLA SANTUL 3 1/2 LA 89 MM 7780*, ALICATA P/CUTICULA 4 CORTE COMPLETO', '2014-07-26 20:46:03.072-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (64, 3, 5, 7, 410.087258312851191, 42.1132373064756393, 3, 3, 'Pasaje Crane Ranch 903', 'Envio de: CINCHO 500X4.5 MM 25PZ VOLTECH NATURAL V, CHAPA P/MUEBLE MAX TOOLS CROMO BRILLA, TAQUETE PLASTICO 5/16 50 PZS BOLSA FIER', '2008-04-22 11:08:35.6352-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (65, 7, 6, 8, 917.637178432196379, 664.564868658781052, 1, 1, 'Prolongacion Barlas 102', 'Envio de: ESPATULA 4 MAX-TOOL, EXTRACTOR P/TORNILLO 5 PZAS MAR RAM, MOLINO DE CARNE NO.8 LION TOOLS', '2010-12-25 16:30:48.5856-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (66, 9, 6, 1, 500.029948297888041, 511.955660991370678, 3, 1, 'Jiron Hugh Cargill 120', 'Envio de: CORTADORA DE METALES DEWALT BD28710, DESARMADOR SANTUL CRUZ 5/16X6 7198 PROMO, CALEN. ALUM. 3', '2008-04-19 01:22:57.36-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (67, 8, 8, 3, 120.578692983835936, 708.603191878646612, 1, 1, 'Jiron S Flambeau 786', 'Envio de: GANCHO P/CORTINA C/1000 PZ. *, RUEDA P/DIABLO DOBLE BALERO  6, MARRO 2 LIBRAS MAR-RAM', '2005-03-03 19:47:55.6224-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (68, 6, 8, 10, 847.241154629737139, 711.764784753322601, 1, 1, 'Prolongacion N Grotto 500', 'Envio de: POLIDUCTO FLEXIBLE 3/4 CON GUIA, CLAVO SIN CABEZA 1 FIERO KILO, CINCEL AKSI 5/8X10', '2014-10-24 22:39:08.928-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (69, 5, 9, 8, 128.215611204504967, 114.985056910663843, 2, 1, 'Pasaje Doranne 558', 'Envio de: CARGADOR DE BATERIAS LOZADA GRANDE, P/AUDIO 3.5 A 3.5 1.3MTS MITZU CA, PISTOLA P/PINTAR TRUPER PIPI-26 BAJA PE$', '2014-01-27 22:03:27.1584-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (70, 9, 3, 5, 912.554729487746954, 255.388313662260771, 1, 3, 'Pasaje N Pulaski 487', 'Envio de: CADENA CASTIGO 5 MAR-RAM REFORZADA, MANERALES FOSET P/REGADERA AZUL, CARDA SURTEK P/TAL COPA 1 3/4 ZANCO 1/4', '2009-01-14 06:42:51.984-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (71, 2, 5, 2, 250.051825530827045, 425.924487169831991, 2, 1, 'Pasaje E Birchwood 540', 'Envio de: LINTERNA TEMPESTAD PLATEADA LION TOOL, PINZA PUNTA-CORTE #4 MINI MAXTOOL PU4, CHAPA P/RECAMARA RAM-TOOLS COPA DORADA', '2007-01-14 06:08:25.6416-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (72, 9, 9, 8, 540.62022477388382, 695.505227651447058, 3, 3, 'Pasaje Happ 425', 'Envio de: PIEDRA PARA TALADRO AUSTROMEX 3X1/2X1/2, TORNILLO ACERO INOX MAQUI 1/4X1 100PZS., PIJA P/LAMINA 8X5/8 CON 200 PZS', '2011-04-16 01:16:41.8656-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (73, 9, 1, 2, 608.888374399393797, 140.049087107181549, 3, 2, 'Avenida E Mount Ida 666', 'Envio de: DADO (3/8) 13/16 CROMO KNOVA, LLAVE DE PASO 1/2 ROSCABLE FOSET TRU  B, MARTILLO U¥A 16 ONZ MADERA CURVA M/HICOR', '2008-05-27 18:58:35.6448-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (74, 6, 9, 2, 95.4663723148405552, 215.531036015599966, 3, 1, 'Pasaje Woden 788', 'Envio de: CODO POLIDUCTO 1/2 *, LONA LIGERA ROJA 20X40 (6.00X12.00), LIMA TRIAN 8 TRUPER PESADO S/M LTP-8 $*', '2008-04-06 05:19:49.296-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (75, 2, 4, 4, 492.559328433126211, 579.138869643211365, 3, 1, 'Pasaje Bellwood 876', 'Envio de: MARTILLO DE BOLA TRUPER  4 OZ., TEE TERMOFLOW REDICIDA 3/4X1/2X1/2, KIT TRUPER CORTACIRCULOS KIT-14 15PZS', '2006-05-23 13:11:30.9984-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (76, 3, 7, 3, 836.477351598441601, 933.73570054769516, 1, 2, 'Avenida N Seminary 708', 'Envio de: ACCESORIO P/TALADRO BOLSA, GRAPA ET-21-3/8 TRUPER, LINTERNA  1+10 LED RAM-TOOLS RECAR NUEVA', '2006-07-18 13:21:20.2464-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (77, 9, 10, 5, 851.752414125949144, 706.23140012845397, 2, 1, 'Jiron Hermon 953', 'Envio de: REMACHE FIERO STD R-68LF 50PZ 3/16X«, REMACHADORA SANTUL 7740 C/REMACHES, ENGRAPADORA ET-19 AKSI DE PARED', '2014-09-28 06:37:15.024-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (78, 4, 1, 1, 797.645718548446894, 959.16330324485898, 3, 1, 'Prolongacion Bysing Wood 607', 'Envio de: SOPORTE MITZU UNIVER 17 A 37 45K TV LCD, CUCHILLO PARA ELECTRICISTA TRUPER CUEL-6, LONA LIGERA ROJA 18X24 (5.40X7.20)', '2011-03-30 15:02:49.4592-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (79, 7, 10, 9, 84.4809689931571484, 340.020240042358637, 2, 2, 'Pasaje Passage 41', 'Envio de: ANTENA SANELEC GIRATORIA LIBELULA CONTRO, HIDROLAVADORA SANELEC 2200PSI ELECTRICA, GUADA¥A TRUPER AUSTRIACA 26 GT-26 šššš', '2007-03-05 05:23:56.832-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (80, 9, 9, 8, 96.0098437406122684, 640.032772663980722, 1, 2, 'Prolongacion Macclesfield Main 588', 'Envio de: CALADORA TRUPER PROFESIONAL CALA-A2, TECLADO Y MOUSE MITZU OPTICO NEGRO, EXTEN. BARRA 4 PZS 3/8 MAR-RAM PROFES', '2009-01-29 06:16:41.7504-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (81, 7, 7, 7, 235.982584059238434, 657.651550825685263, 1, 2, 'Pasaje Sise 127', 'Envio de: CUTTER 6 SANTUL 5904 ALMA METALICA, SIERRA TRUPER P/ALUMINIO 100 D ST-10100A, CONECTOR COBRE 1 SOLDABLE C/EXTERIOR F', '2014-07-22 10:09:40.32-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (82, 3, 6, 6, 603.137357849627733, 622.793023698031902, 2, 3, 'Avenida Pakan 470', 'Envio de: TAQUETE PLASTICO 3/8 AKSI 50 PZS      B, LIMA TRIANGULO DOBLE TRUPER LTD-6 *, CARTUCHO P/ENCENDEDOR GRANDE', '2009-12-03 15:03:24.2784-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (83, 10, 2, 1, 510.020255800336599, 266.546825170516968, 1, 2, 'Pasaje Old Boonton 375', 'Envio de: CALEN. ALUM. 5 DAYCO AMARILLO, CHAPA PHILLIPS 800 FIJA IZQUIERDA LL/PLA, HILO REVENTON CHICO MAX-TOOLS 65 MTS', '2011-01-02 07:37:53.0688-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (84, 8, 1, 6, 302.512221727520227, 832.380297817289829, 1, 2, 'Avenida Frewland 851', 'Envio de: LONA S AZUL 17X17(5.10X5.10), GUANTE AKSI TIPO JAPONES CON PUNTOS P, MATRACA DOBLE MAR-RAM 3/8 X 1/2 GRANDE', '2014-04-16 13:44:57.2064-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (85, 6, 1, 8, 937.074368577450514, 917.662092242389917, 1, 3, 'Avenida Redbourne 466', 'Envio de: MALLA CICLONICA 12.5 63X63 2X20 FIERO, VALVULA DE RETENCION 3/4 SANPLOM 8554, LONA EXTRA ROSA 10X14(3.00X4.20)********', '2005-03-08 03:29:44.7072-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (86, 5, 4, 10, 1008.72945202514529, 339.331832472234964, 2, 2, 'Jiron W Ontario 168', 'Envio de: MULTICONTACTO VOLTECH 14 AWG USO RUDO, REP. DESPACHADOR PUNTAS PLANAS 10 PZ, REMACHE FIERO STD R-48B 50PZS 1/8X1/2', '2009-08-04 10:57:04.5216-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (87, 5, 1, 8, 251.933612618595362, 823.924658577889204, 3, 1, 'Avenida Greys 376', 'Envio de: DESARMADOR PRETUL 1/4X8 PHILLIPS TRANSP, LLAVE MIXTA MM 17 PRETUL LL-1217MP *, CUCHILLO VILMA PANADERO NO.8 4450', '2005-03-04 20:43:42.672-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (88, 9, 1, 3, 821.381069011986256, 204.474850315600634, 1, 1, 'Avenida Alwyne 777', 'Envio de: CALEN. ALUM. 5, MANGUERA LISA  5/8 JARDIN, FOCO OSRAM Y/O PHILIPS TUBO SLIM 60 T8', '2011-07-30 13:50:17.3184-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (89, 7, 1, 6, 494.790404327213764, 719.131570067256689, 2, 1, 'Calle Narelle 459', 'Envio de: TIRA DE LED 5 MTS MITZU 60 LED BLANCA, ADAPTADOR P/DADO SURTEK 1/43/81/2, LONA EXTRA GRIS  6X8 (1.80X2.40)', '2009-12-11 04:24:22.1184-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (90, 2, 7, 4, 154.187256693840027, 803.534758966416121, 3, 3, 'Jiron Hansletts 665', 'Envio de: CANDADO HERMEX HIERRO CORAZA 50 MM ABLOY, CINCEL TRUPER 3/8X8, MARRO PRETUL 12 LBS MD-12MP', '2008-01-14 11:33:22.4064-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (91, 8, 4, 8, 735.066750776022673, 159.388568941503763, 2, 2, 'Avenida Marshalltown 983', 'Envio de: ESPATULA 2 PRETUL E-2F *, CLAVO P/CONCRETO GALVANIZADO 3« KILO, PLASTIACERO SUPER RAPIDO PASTA SR1-56 *', '2014-07-17 23:20:45.1104-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (92, 10, 5, 6, 141.920912303030491, 208.167979251593351, 1, 3, 'Avenida Lower Lodge 316', 'Envio de: BROCHA 6 MAX-TOOLS *, CABLE NO.22 BICOLOR VOLTECH, LONA EXTRA BLANCA 20X27(6.00X8.00) N', '2006-05-14 13:04:08.3712-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (93, 3, 3, 1, 216.660173367708921, 30.6284290179610252, 2, 3, 'Prolongacion Thirlwater 373', 'Envio de: CANDADO LOCK CORAZA ACERO 60 MM ABLOY, DADO (3/8) 7/8 SURTEK CORTO 6 PTS, LLAVE TORX 7 PZS SANTUL 8744', '2013-12-31 14:31:50.6496-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (94, 4, 2, 10, 954.499465636909008, 921.974546499550343, 1, 3, 'Pasaje Turlock 764', 'Envio de: PINZA MIXTA 4 PZS ELE8 PUNT8 CORT8 PER10, MALLA CICLONICA 12.5 63X63 2X20 FIERO, NIPLE GALVANIZADO 3/4 2 5 CM CEDU 40 B', '2010-09-06 17:44:03.6672-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (95, 4, 5, 3, 399.801508281379938, 915.662259086966515, 1, 1, 'Calle Guilfoy 440', 'Envio de: MULTICONTACTO  3 PZS SANELEC BLANCO EXTE, PALA REDONDA TRUPER CLASSIC P/D  PRY, LONA EXTRA VERDE 10X14(3.00X4.20)AL CORT', '2007-03-26 02:06:09.792-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (96, 3, 1, 9, 106.657922491431236, 484.710073322057724, 3, 3, 'Avenida Cherwal 410', 'Envio de: DADO CORTO 1 13/16, CAMA PARA MECANICO SURTEK 36X17, GUANTE CARNAZA AMERICANO AZUL C/HILO KEV', '2014-07-13 16:38:09.2256-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (97, 1, 10, 3, 12.8275432996451855, 510.750714913010597, 2, 2, 'Pasaje S Diagonal 517', 'Envio de: EJE P/DIABLO 40 CM. * EJ50110, FAJA AKSI CON TIRANTES TALLA MEDIANA, DESARMADOR MAR-RAM CRUZ 1/4X6 2 ANTIDER', '2005-03-31 00:35:41.9712-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (98, 9, 9, 8, 357.12932538241148, 119.297438059002161, 2, 2, 'Prolongacion Cembellin 917', 'Envio de: REFLECTOR 50 W SANELEC ILUMINA 1500 L/FR, LONA EXTRA ROJA 34X40(10.00X12.00), LLANTA INFLABLE 10*MAR-RAM BALERO 5/8', '2014-06-11 20:11:38.1984-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (99, 3, 2, 4, 683.336741980165243, 17.3731406591832638, 1, 3, 'Jiron Dutch Ship 261', 'Envio de: REMACHE FIERO STD R-66B 50PZS 3/16X3/8, STILSON NO. 8 TAIWAN *, ENGRAPADORA ET-50 SANTUL MOD.7972*', '2010-05-19 13:54:41.9616-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (100, 3, 10, 4, 654.376037176698446, 17.8122005797922611, 1, 2, 'Prolongacion Avian 703', 'Envio de: LLAVE MIXTA 1 ROTTER, LO LONA EXTRA NEGRA 14X20(4.20X6.00), DIABLO MAR-RAM PLEGABLE 60-80 KG NEGRO', '2014-08-11 11:43:07.5936-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (101, 2, 20, 12, 33, 33, 1, 1, 'Direccion 2123 al costado', 'Nuevo presupuesto', '2016-11-29 11:16:16.827526-05');
INSERT INTO presupuesto (id, id_presupuestador, id_partida, id_destino, precio, peso, id_fragilidad, id_prioridad, direccion, descripcion, fecha) VALUES (102, 2, 1, 2, 11, 33, 3, 1, 'Su casa', 'PResupeusto test', '2016-11-29 16:15:32.630158-05');


--
-- TOC entry 2443 (class 0 OID 0)
-- Dependencies: 201
-- Name: presupuesto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('presupuesto_id_seq', 102, true);


--
-- TOC entry 2409 (class 0 OID 95191)
-- Dependencies: 204
-- Data for Name: prioridad; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO prioridad (id, nombre, indice_prioridad) VALUES (1, 'Normal', 1);
INSERT INTO prioridad (id, nombre, indice_prioridad) VALUES (2, 'Urgente', 1.19999999999999996);
INSERT INTO prioridad (id, nombre, indice_prioridad) VALUES (3, 'Muy Urgente', 1.39999999999999991);


--
-- TOC entry 2444 (class 0 OID 0)
-- Dependencies: 203
-- Name: prioridad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('prioridad_id_seq', 3, true);


--
-- TOC entry 2410 (class 0 OID 95198)
-- Dependencies: 205
-- Data for Name: registro_modificacion_vehiculo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2445 (class 0 OID 0)
-- Dependencies: 206
-- Name: registro_modificacion_vehiculo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('registro_modificacion_vehiculo_id_seq', 1, false);


--
-- TOC entry 2412 (class 0 OID 95206)
-- Dependencies: 207
-- Data for Name: tabPrueba; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('ostras', 'juan', 'cruz', 1);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('yogurt', 'loco', 'vargas', 2);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('norma', 'santos', 'bedregal', 3);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('luis', 'calle', 'castañeda', 4);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('jose', 'pepino', NULL, 5);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('juan', 'uno', NULL, 6);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES (NULL, NULL, NULL, 7);
INSERT INTO "tabPrueba" (nombres, apellido, edad, id) VALUES ('juan', 'dos', NULL, 8);


--
-- TOC entry 2446 (class 0 OID 0)
-- Dependencies: 208
-- Name: tabPrueba_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"tabPrueba_id_seq"', 8, true);


--
-- TOC entry 2414 (class 0 OID 95214)
-- Dependencies: 209
-- Data for Name: tabla_cambio_apellido; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'fuji', 3);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Quispe', 4);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Quispe', 5);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Quispe', 6);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Go', 7);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Quispe', 8);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Quispe', 9);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Quispe', 'Quispe', 10);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Gomez', 'Juarez', 11);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Gomez', 'Gomez', 12);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Gomez', 'Gomez', 13);
INSERT INTO tabla_cambio_apellido (ap_ant, ap_nuevo, id) VALUES ('Gomez', 'Gomez', 14);


--
-- TOC entry 2447 (class 0 OID 0)
-- Dependencies: 210
-- Name: tabla_cambio_apellido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('tabla_cambio_apellido_id_seq', 14, true);


--
-- TOC entry 2417 (class 0 OID 95224)
-- Dependencies: 212
-- Data for Name: trabajador; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (1, '2010-11-12 00:00:00-05', 1);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (2, '2008-07-11 00:00:00-05', 2);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (3, '2015-08-19 00:00:00-05', 3);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (4, '2011-01-16 00:00:00-05', 4);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (5, '2009-08-12 00:00:00-05', 5);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (6, '2002-09-14 00:00:00-05', 6);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (7, '2002-04-12 00:00:00-05', 7);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (8, '2014-07-01 00:00:00-05', 8);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (9, '2014-07-14 00:00:00-05', 9);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (10, '2002-07-12 00:00:00-05', 10);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (11, '2001-11-14 00:00:00-05', 21);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (12, '2015-01-21 00:00:00-05', 22);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (13, '2010-05-14 00:00:00-05', 23);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (14, '2008-11-29 00:00:00-05', 24);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (15, '2009-02-02 00:00:00-05', 25);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (16, '2003-08-10 00:00:00-05', 26);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (17, '2001-01-01 00:00:00-05', 27);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (18, '2000-06-19 00:00:00-05', 28);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (19, '1997-05-22 00:00:00-05', 29);
INSERT INTO trabajador (id, fecha_contratacion, id_persona) VALUES (20, '2012-04-02 00:00:00-05', 30);


--
-- TOC entry 2448 (class 0 OID 0)
-- Dependencies: 211
-- Name: trabajador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('trabajador_id_seq', 20, true);


--
-- TOC entry 2419 (class 0 OID 95230)
-- Dependencies: 214
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (1, 'Administrador', 'Administrador');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (11, 'rsucre', '378273');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (12, 'bmesa', '3323111');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (13, 'jccari', '1212123');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (14, 'jbueno', '131313');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (15, 'rvaldivia', '318848');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (16, 'jlagos', '747474');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (17, 'mmanrique', '3788878');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (18, 'dbenavente', '74274728');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (19, 'dmalo', '378731');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (20, 'otejado', '3718378');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (21, 'mroque', '37373');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (22, 'jwong', '2781738');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (23, 'myana', '78173813');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (24, 'cweisn', '37817381');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (25, 'mmachaca', '1783781');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (26, 'claura', '37467272');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (27, 'rmalaga', 'ashdksjds');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (28, 'oreyes', 'qwerty');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (29, 'jballon', '1213456');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (30, 'acastro', 'wasd0123');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (2, 'jccary', '73120716');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (4, 'dpumaraime', '23456789');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (5, 'pdueñas', '34567890');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (6, 'mpinto', '45678901');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (7, 'jbasadre', '56789012');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (8, 'mmiller', '67890123');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (9, 'narendegui', '78901234');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (10, 'lbravo', '89012345');
INSERT INTO usuario (id, nombre_usuario, "contraseña") VALUES (3, 'oluza', '123');


--
-- TOC entry 2449 (class 0 OID 0)
-- Dependencies: 213
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usuario_id_seq', 30, true);


--
-- TOC entry 2421 (class 0 OID 95239)
-- Dependencies: 216
-- Data for Name: vehiculo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (1, 'AOK-778', 'Nissan', 'Classic');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (2, 'UVH-991', 'Nissan', 'Classic');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (3, 'OBG-491', 'Daewoo', 'NT');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (4, 'UDH-981', 'Nissan', 'Navara');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (5, 'AVD-455', 'Opel', 'Corsa');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (6, 'AGH-596', 'Seat', 'Toledo');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (7, 'UVG-961', 'Nissan', 'Centra');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (8, 'ODB-102', 'Cartago', 'JX');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (9, 'UVG-450', 'Daewoo', 'NT');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (11, 'qqq', 'www', 'eee');
INSERT INTO vehiculo (id, matricula, marca, modelo) VALUES (10, 'MHJ-998', 'Peugeotsdsd', '308');


--
-- TOC entry 2450 (class 0 OID 0)
-- Dependencies: 215
-- Name: vehiculo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vehiculo_id_seq', 11, true);


--
-- TOC entry 2221 (class 2606 OID 95250)
-- Name: id_carga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY carga
    ADD CONSTRAINT id_carga_pkey PRIMARY KEY (id);


--
-- TOC entry 2223 (class 2606 OID 95252)
-- Name: id_chofer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chofer
    ADD CONSTRAINT id_chofer_pkey PRIMARY KEY (id);


--
-- TOC entry 2225 (class 2606 OID 95400)
-- Name: id_ciudades_de_reparto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ciudades_de_reparto
    ADD CONSTRAINT id_ciudades_de_reparto_pkey PRIMARY KEY (id);


--
-- TOC entry 2227 (class 2606 OID 95256)
-- Name: id_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT id_cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 2229 (class 2606 OID 95258)
-- Name: id_entrega_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entrega
    ADD CONSTRAINT id_entrega_pkey PRIMARY KEY (id);


--
-- TOC entry 2231 (class 2606 OID 95260)
-- Name: id_fragilidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY fragilidad
    ADD CONSTRAINT id_fragilidad_pkey PRIMARY KEY (id);


--
-- TOC entry 2233 (class 2606 OID 95262)
-- Name: id_historial_de_quejas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY historial_quejas
    ADD CONSTRAINT id_historial_de_quejas_pkey PRIMARY KEY (id);


--
-- TOC entry 2235 (class 2606 OID 95264)
-- Name: id_paquete_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paquete
    ADD CONSTRAINT id_paquete_pkey PRIMARY KEY (id);


--
-- TOC entry 2237 (class 2606 OID 95266)
-- Name: id_persona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT id_persona_pkey PRIMARY KEY (id);


--
-- TOC entry 2239 (class 2606 OID 95268)
-- Name: id_presupuestador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prespupuestador
    ADD CONSTRAINT id_presupuestador_pkey PRIMARY KEY (id);


--
-- TOC entry 2241 (class 2606 OID 95270)
-- Name: id_presupuesto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT id_presupuesto_pkey PRIMARY KEY (id);


--
-- TOC entry 2243 (class 2606 OID 95272)
-- Name: id_prioridad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prioridad
    ADD CONSTRAINT id_prioridad_pkey PRIMARY KEY (id);


--
-- TOC entry 2245 (class 2606 OID 95274)
-- Name: id_trabajador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT id_trabajador_pkey PRIMARY KEY (id);


--
-- TOC entry 2247 (class 2606 OID 95276)
-- Name: id_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT id_usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 2249 (class 2606 OID 95278)
-- Name: id_vehiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vehiculo
    ADD CONSTRAINT id_vehiculo_pkey PRIMARY KEY (id);


--
-- TOC entry 2267 (class 2620 OID 95279)
-- Name: historial_cambio_apellido; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER historial_cambio_apellido BEFORE UPDATE OF apellido_materno ON persona FOR EACH ROW EXECUTE PROCEDURE historial_persona();


--
-- TOC entry 2268 (class 2620 OID 95280)
-- Name: historial_cambio_apellido1; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER historial_cambio_apellido1 BEFORE UPDATE OF apellido_materno ON persona FOR EACH ROW EXECUTE PROCEDURE historial_persona();


--
-- TOC entry 2269 (class 2620 OID 95281)
-- Name: historial_cambio_apellido2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER historial_cambio_apellido2 BEFORE UPDATE OF apellido_materno ON persona FOR EACH ROW EXECUTE PROCEDURE historial_persona();


--
-- TOC entry 2270 (class 2620 OID 95282)
-- Name: historial_cambio_apellido3; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER historial_cambio_apellido3 BEFORE UPDATE OF apellido_materno ON persona FOR EACH ROW EXECUTE PROCEDURE historial_persona();


--
-- TOC entry 2271 (class 2620 OID 95283)
-- Name: tg_modificacion_vehiculo; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tg_modificacion_vehiculo BEFORE DELETE ON vehiculo FOR EACH ROW EXECUTE PROCEDURE modificacion_vehiculo();


--
-- TOC entry 2250 (class 2606 OID 95284)
-- Name: carga_fkey_id_chofer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY carga
    ADD CONSTRAINT carga_fkey_id_chofer FOREIGN KEY (id_chofer) REFERENCES chofer(id);


--
-- TOC entry 2251 (class 2606 OID 95289)
-- Name: chofer_fkey_id_trabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chofer
    ADD CONSTRAINT chofer_fkey_id_trabajador FOREIGN KEY (id_trabajador) REFERENCES trabajador(id);


--
-- TOC entry 2252 (class 2606 OID 95294)
-- Name: chofer_fkey_id_vehiculo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY chofer
    ADD CONSTRAINT chofer_fkey_id_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id);


--
-- TOC entry 2253 (class 2606 OID 95299)
-- Name: cliente_fkey_id_persona; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_fkey_id_persona FOREIGN KEY (id_persona) REFERENCES persona(id);


--
-- TOC entry 2254 (class 2606 OID 95304)
-- Name: entrega_fkey_id_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entrega
    ADD CONSTRAINT entrega_fkey_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id);


--
-- TOC entry 2255 (class 2606 OID 95309)
-- Name: entrega_fkey_id_presupuesto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY entrega
    ADD CONSTRAINT entrega_fkey_id_presupuesto FOREIGN KEY (id_presupuesto) REFERENCES presupuesto(id);


--
-- TOC entry 2256 (class 2606 OID 95314)
-- Name: historial_quejas_fkey_id_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY historial_quejas
    ADD CONSTRAINT historial_quejas_fkey_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id);


--
-- TOC entry 2257 (class 2606 OID 95319)
-- Name: paquete_fkey_id_carga; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paquete
    ADD CONSTRAINT paquete_fkey_id_carga FOREIGN KEY (id_carga) REFERENCES carga(id);


--
-- TOC entry 2258 (class 2606 OID 95324)
-- Name: paquete_fkey_id_entrega; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY paquete
    ADD CONSTRAINT paquete_fkey_id_entrega FOREIGN KEY (id_entrega) REFERENCES entrega(id);


--
-- TOC entry 2259 (class 2606 OID 95329)
-- Name: persona_fkey_id_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY persona
    ADD CONSTRAINT persona_fkey_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id);


--
-- TOC entry 2260 (class 2606 OID 95334)
-- Name: presupuestador_fkey_id_trabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY prespupuestador
    ADD CONSTRAINT presupuestador_fkey_id_trabajador FOREIGN KEY (id_trabajador) REFERENCES trabajador(id);


--
-- TOC entry 2264 (class 2606 OID 95401)
-- Name: presupuesto_fkey_id_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT presupuesto_fkey_id_destino FOREIGN KEY (id_destino) REFERENCES ciudades_de_reparto(id);


--
-- TOC entry 2261 (class 2606 OID 95344)
-- Name: presupuesto_fkey_id_fragilidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT presupuesto_fkey_id_fragilidad FOREIGN KEY (id_fragilidad) REFERENCES fragilidad(id);


--
-- TOC entry 2265 (class 2606 OID 95406)
-- Name: presupuesto_fkey_id_partida; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT presupuesto_fkey_id_partida FOREIGN KEY (id_partida) REFERENCES ciudades_de_reparto(id);


--
-- TOC entry 2262 (class 2606 OID 95354)
-- Name: presupuesto_fkey_id_prioridad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT presupuesto_fkey_id_prioridad FOREIGN KEY (id_prioridad) REFERENCES prioridad(id);


--
-- TOC entry 2263 (class 2606 OID 95359)
-- Name: presupuesto_fkey_id_trabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY presupuesto
    ADD CONSTRAINT presupuesto_fkey_id_trabajador FOREIGN KEY (id_presupuestador) REFERENCES trabajador(id);


--
-- TOC entry 2266 (class 2606 OID 95364)
-- Name: trabajador_fkey_id_persona; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT trabajador_fkey_id_persona FOREIGN KEY (id_persona) REFERENCES persona(id);


--
-- TOC entry 2428 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2016-11-29 16:56:51 PET

--
-- PostgreSQL database dump complete
--

