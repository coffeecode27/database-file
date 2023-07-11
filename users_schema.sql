CREATE TABLE users.business_entity (
    entity_id serial primary key --pk
   
);

CREATE TABLE users.roles (
    role_id serial primary key, --pk
	role_name varchar(35) unique,
	role_type varchar(15),
	role_modified_date timestamp	
);


CREATE TABLE users.users (
    user_entity_id int primary key, --pk,fk
    user_name varchar(15) unique,
	user_password varchar(256),
	user_first_name varchar(50),
	user_last_name varchar(50),
	user_birth_date timestamp,
	user_email_promotion int default 0,
	user_demographic json,
	user_modified_date timestamp,
	user_photo varchar(255),
	user_current_role int, --fk
	constraint FK_user_entity_id foreign key (user_entity_id) references users.business_entity (entity_id),
	 constraint fk_user_current_role foreign key (user_current_role) references users.roles(role_id)
);


CREATE TABLE users.users_roles (
    usro_entity_id int, --pk,fk
	usro_role_id int, --pk,fk
	usro_modified_date timestamp,
	constraint PK_usro_entity_id_and_usro_role_id primary key(usro_entity_id, usro_role_id),
	constraint FK_usro_entity_id foreign key (usro_entity_id) references users.users (user_entity_id),
	constraint FK_usro_role_id foreign key (usro_role_id) references users.roles (role_id)
);


CREATE TABLE users.users_skill (
    uski_id serial, --fk
	uski_entity_id int, --fk,pk
	uski_modified_date timestamp,
	uski_skty_name varchar(15) unique, -- uski_skty_name reference to skty_name module master
	constraint PK_uski_id_and_uski_entity_id primary key(uski_id, uski_entity_id),
	constraint FK_uski_entity_id foreign key (uski_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.users_experiences (
    usex_id serial, --pk
	usex_entity_id int, --pk,fk
	usex_title varchar(255),
	usex_profile_headline varchar(512),
	usex_employment_type varchar(15) CHECK (usex_eployment_type IN ('fulltime', 'freelance')),
	usex_company_name varchar(255),
	usex_is_current char(1) CHECK (usex_is_current IN ('0', '1')),
	usex_start_date timestamp,
	usex_end_date timestamp,
	usex_industry varchar(15),
	usex_description varchar(512),
	usex_experience_type varchar(15) CHECK (usex_experience_type IN ('company', 'certified', 'voluntering', 'organization', 'reward')),
    usex_city_id int, --fk dari table city dalam module master
	constraint PK_usex_id_and_usex_entity_id primary key(usex_id, usex_entity_id),
	constraint FK_usex_entity_id foreign key (usex_entity_id) references users.users (user_entity_id)
);

--tambahkan constraint unique agar bisa dipakai sebagai referensi foreign key--
ALTER TABLE users.users_experiences
ADD CONSTRAINT unique_usex_id UNIQUE (usex_id);

--tambahkan constraint unique agar bisa dipakai sebagai referensi foreign key--
ALTER TABLE users.users_skill
ADD CONSTRAINT unique_uski_id UNIQUE (uski_id);

CREATE TABLE users.users_experiences_skill (
    uesk_usex_id int, --pk,fk
	uesk_uski_id int, --pk,fk
	constraint PK_uesk_usex_id_and_uesk_uski_id primary key(uesk_usex_id, uesk_uski_id),
    constraint FK_uesk_usex_id foreign key (uesk_usex_id) references users.users_experiences (usex_id),
	constraint FK_uesk_uski_id foreign key (uesk_uski_id) references users.users_skill (uski_id)
);


CREATE TABLE users.users_license (
    usli_id serial, --pk
	usli_license_code varchar(512)unique,
	usli_modified_date timestamp,
	usli_status varchar(15) CHECK (usli_status IN ('active', 'NonActive')),
	usli_entity_id int, --pk,fk
	constraint PK_usli_id_and_usli_entity_id primary key(usli_id, usli_entity_id),
    constraint FK_usli_entity_id foreign key (usli_entity_id) references users.users (user_entity_id)
);

CREATE TABLE users.users_email(
	pmail_entity_id int, --pk,fk
	pmail_id serial, --pk
	pmail_address varchar(50),
	pmail_modified_date timestamp,
	constraint PK_pmail_entity_id_and_pmail_id primary key(pmail_entity_id, pmail_id),
    constraint FK_pmail_entity_id foreign key (pmail_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.users_media(
	usme_id serial, --pk
	usme_entity_id int, --pk,fk
	usme_file_link varchar(255),
	usme_filename varchar(55),
	usme_filesize int,
	usme_filetype varchar(15) CHECK (usme_filetype IN ('jpg', 'pdf', 'word')),
	usme_note varchar(55),
	usme_modified_date timestamp,
	constraint PK_usme_id_and_usme_entity_id primary key(usme_id, usme_entity_id),
    constraint FK_usme_entity_id foreign key (usme_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.users_education(
	usdu_id serial, --pk
	usdu_entity_id int, --pk,fk
	usdu_school varchar(255),
	usdu_degree varchar(15) CHECK (usdu_degree IN ('Bachelor', 'Diploma')),
	usdu_field_study varchar(125),
	usdu_graduate_year varchar(4),
	usdu_start_date timestamp,
	usdu_end_date timestamp,
	usdu_grade varchar(5),
	usdu_activities varchar(512),
	usdu_description varchar(512),
	usdu_modified_date timestamp,
	constraint PK_usdu_id_and_usdu_entity_id primary key(usdu_id, usdu_entity_id),
    constraint FK_usdu_entity_id foreign key (usdu_entity_id) references users.users (user_entity_id)
);


CREATE TABLE users.phone_number_type(
	ponty_code varchar(15) primary key, --pk
	ponty_modified_date timestamp
);


CREATE TABLE users.users_phones(
	uspo_entity_id int, --pk,fk
	uspo_number varchar(15), --pk
	uspo_modified_date timestamp,
	uspo_ponty_code varchar(15), --fk
	constraint PK_uspo_entity_id_and_uspo_number primary key(uspo_entity_id, uspo_number),
    constraint FK_uspo_entity_id foreign key (uspo_entity_id) references users.users (user_entity_id),
	constraint FK_uspo_ponty_code foreign key (uspo_ponty_code) references users.phone_number_type (ponty_code)
);


CREATE TABLE users.users_address(
	etad_addr_id int primary key, --pk,fk reference ke table address pada module master
	etad_modified_date timestamp,
	etad_entity_id int, --fk
	etad_adty_id int, --fk reference ke table address_type pada module master
	constraint FK_etad_entity_id foreign key (etad_entity_id) references users.users (user_entity_id)
);

------------ QUERY INPUT DATA -------------------

insert into users.business_entity values
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9);

insert into users.roles values
(1,	'Candidat',	'external'),
(2,	'Talent',	'external'),
(3,	'Recruiter', 'Internal'),
(4,	'Instructor',	'Internal'),
(5,	'Sales',	'Internal'),
(6,	'Manager',	'Internal'),
(7,	'Vice President',	'Internal'),
(8,	'Account Manager',	'Internal'),
(9,	'Student',	'external'),
(10,'Administrator',	'Internal'),
(11,'outsource',	'Internal'),
(12,'Employee',	'Internal');


INSERT INTO users.users (user_entity_id, user_name, user_first_name, user_last_name, user_email_promotion,
                         user_modified_date, user_demographic, user_photo, user_current_role, user_password) VALUES
(1, 'kangdian', 'kang', 'dian', 1, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'photo.png', 4, 'yadfaldjfapdjf;ajfpasdf'),
(2, 'nofal', 'nofal', 'firdaus', 0, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'nofal.png', 4, 'ajdfja;dfpadjfadf'),
(3, 'abdul101', 'Abdul', 'Razaq', 1, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'abdul.png', 1, 'alsdjfapdfaodfadf'),
(4, 'ratih', 'ratih', 'wina ludwig', 0, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'ratih.png', 11, 'yadlfjadjfa'),
(5, 'Eka', 'Eka', 'Nugroho', 0, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'eka.png', 8, 'ynyaldjf;adfadfad;faldfsa'),
(6, 'novia', 'novia', 'slebew', 1, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'novia.png', 9, 'lajdfljaljdfajdf;a'),
(7, 'novelina', 'novelina', 'lina', 0, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'lina.png', 3, 'lkadjfajdf;adf'),
(8, 'yugo', 'yugo', 'ardan', 1, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'yogo.png', 1, 'aldjfadfa;dfjlajdf;a'),
(9, 'andhika', 'andhika', 'pratama', 1, '2022-07-12', '{"latitude": 12.90, "longitude": -99.989}', 'andhika.png', 2, 'ladfljafjadfas;f');


INSERT INTO users.users_roles VALUES
(1, 1, '2022-12-07'),
(2, 1, '2022-12-07'),
(3, 3, '2022-12-07'),
(4, 5, '2022-12-07');


INSERT INTO users.users_skill(uski_id, uski_entity_id, uski_skty_name) VALUES
(1, 1, 'java'),
(2, 1 ,'dotnet'),
(3, 2 ,'javascript');

INSERT INTO users.users_experiences(usex_id, usex_entity_id, usex_title, usex_profile_headline, 
						usex_employment_type, usex_company_name, usex_city_id, usex_is_current,
						usex_start_date, usex_end_date, usex_industry, usex_description,
						usex_experience_type) VALUES
(1, 1, 'Head Of Bootcamp', '', 'fulltime', 'Code.id', 1, '1', '2019-07-12', '2020-07-12',
 'Consultant','I believe..', 'company'),
(2, 1, 'Motivator', 'Act as volunter', 'freelance', 'Government', 1, '0', '2019-07-12', '2020-07-12',
 'Government','helping people to learn', 'voluntering');
 

INSERT INTO users.users_experiences_skill VALUES
(1, 1),
(1, 2),
(1, 3);

INSERT INTO users.users_email(pmail_id, pmail_entity_id, pmail_address) VALUES
(1, 1, 'dian@code.id'),
(2, 1, 'dian@gmail.com'),
(3, 2, 'nofal@code.id');

INSERT INTO users.users_media(usme_id, usme_entity_id, usme_file_link, usme_filename,
							 usme_filesize, usme_filetype, usme_note) VALUES
(1, 1, 'https://', 'ijazah.png', 2345, 'jpg', 'ijazah'),
(2, 1, 'https://', 'cv.docx', 1890, 'word', 'cv');


INSERT INTO users.users_education(usdu_id, usdu_entity_id, usdu_school, usdu_degree, 
								 usdu_field_study, usdu_start_date, usdu_end_date,
								 usdu_grade, usdu_activities, usdu_description) Values
(1, 1, 'MIT', 'Bachelor', 'Informatic', '2000-07-12', '2005-08-12', '3.45', 'I''m bachelor with cumlaude', '');

INSERT INTO users.phone_number_type VALUES
('Home', '2022-07-12'),
('Cell', '2022-07-12');

INSERT INTO users.users_phones(uspo_entity_id, uspo_number, uspo_ponty_code) VALUES
(1, '8139809091', 'Cell'),
(1, '022-7890987', 'Home'),
(2, '089898989', 'Cell');


INSERT INTO users.users_address(etad_addr_id, etad_entity_id, etad_adty_id) VALUES
(1, 1, 1),
(2, 2, 2);




