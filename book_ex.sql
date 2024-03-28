show tables;
show databases;

help;

help show;

show connenction;

create sequence seq_board;

create table tbl_board (
    bno number(10, 0),
    title varchar2(200) not null,
    content varchar2(2000) not null,
    writer varchar2(50) not null,
    regdate date default sysdate,
    updatedate date default sysdate
);

alter table tbl_board add constraint pk_board primary key(bno);

insert into tbl_board(bno, title, content, writer) values(seq_board.nextval, '스프링 제목', '블라블라', '나');

select * from tbl_board;

commit;

select * from tbl_board order by bno desc;

insert into tbl_board (bno, title, content, writer)
(select seq_board.nextval, title, content, writer from tbl_board);

select * from tbl_board order by bno + 1 desc;

select * from tbl_board where bno > 0;

select
    /*+ index_desc(tbl_board pk_board) */
    *
from
    tbl_board
where bno > 0;

select rownum rn, bno, title, content from tbl_board order by bno;

select /*+ index_asc(tbl_board pk_board) */ rownum rn, bno, title, content from tbl_board;

select /*+ index_desc(tbl_board pk_board) */ rownum rn, bno, title, content from tbl_board where rownum > 10 and rownum <= 20;

select rn, bno, title, content
from
    (select /*+ index_desc(tbl_board pk_board) */
     rownum rn, bno, title, content
     from tbl_board
     where rownum <= 20
     )
where rn > 10;

/*REST 댓글 처리*/
create table tbl_reply (
    rno number(10, 0),
    bno number(10, 0) not null,
    reply varchar2(1000) not null,
    replyer varchar2(50) not null,
    replyDate date default sysdate,
    updateDate date default sysdate
    );
    
    desc tbl_reply;
    
    create sequence seq_reply;
    
    alter table tbl_reply add constraint pk_reply primary key (rno);
    
    alter table tbl_reply add constraint fk_reply_board foreign key (bno) references tbl_board (bno);
    
    desc tbl_reply;
    
    select * from tbl_board where rownum < 10 order by bno desc;
    
    select * from tbl_reply order by rno desc;
    
    select * from tbl_reply where bno = 655371 order by rno asc;
    
    create index idx_reply on tbl_reply(bno desc, rno asc);
    
    select rownum rn, bno, rno, reply, replyer, replyDate, updateDate from tbl_reply
        where bno = 655371
        and rno > 0;
        
    select /*+ INDEX(tbl_reply idx_reply) */
    rownum rn, bno, rno, reply, replyer, replyDate, updateDate from tbl_reply
        where bno = 655371
        and rno > 0;
        
    select rn, rno, bno, reply, replyer, replydate, updatedate from
    (
        select /*+ INDEX(tbl_reply idx_reply) */
        rownum rn, bno, rno, reply, replyer, replyDate, updateDate from tbl_reply
        where bno = 655371
            and rno > 0
            and rownum <= 20
    ) where rn > 10;
    
    create table tbl_sample1( col1 varchar2(500));
    
    create table tbl_sample2( col2 varchar2(50));
    
    select * from tbl_sample1;
    
    select * from tbl_sample2;
    
    delete from tbl_sample1;
    
    commit;
    
    alter table tbl_board add (replycnt number default 0);
    
    update tbl_board set replycnt = (select count(rno) from tbl_reply
    where tbl_reply.bno = tbl_board.bno);
    
    commit;
    
    create table tbl_attach (
        uuid varchar2(100) not null,
        uploadPath varchar2(200) not null,
        fileName varchar2(100) not null,
        filetype char(1) default 'I',
        bno number(10, 0)
    );
    
    alter table tbl_attach add constraint pk_attach primary key (uuid);
    
    alter table tbl_attach add constraint fk_board_attach foreign key (bno) references tbl_board(bno);
    
    commit;
    
    select * from tbl_attach;
    
    delete from tbl_attach where bno = 11;
    
    select * from tbl_board order by bno desc;
    
    /* 인증/권한을 위한 DB */
    create table users (
        username varchar2(50) not null primary key,
        password varchar2(50) not null,
        enabled char(1) default '1'
    );
    
    create table authorities (
        username varchar2(50) not null,
        authority varchar2(50) not null,
        constraint fk_authorities_users foreign key(username) references users(username)
    );
    
    create unique index ix_auth_username on authorities (username, authority);
    
    insert into users (username, password) values ('user00', 'pw00');
    insert into users (username, password) values ('member00', 'pw00');
    insert into users (username, password) values ('admin00', 'pw00');
    
    select * from users;
    
    insert into authorities (username, authority) values ('user00', 'ROLE_USER');
    insert into authorities (username, authority) values ('member00', 'ROLE_MANAGER');
    insert into authorities (username, authority) values ('admin00', 'ROLE_MANAGER');
    insert into authorities (username, authority) values ('admin00', 'ROLE_ADMIN');
    
    select * from authorities;
    
    commit;
    
    create table tbl_member(
        userid varchar2(50) not null primary key,
        userpw varchar2(100) not null,
        username varchar2(100) not null,
        regdate date default sysdate,
        updatedate date default sysdate,
        enabled char(1) default '1'
    );
    
    create table tbl_member_auth(
        userid varchar2(50) not null,
        auth varchar2(50) not null,
        constraint fk_member_auth foreign key(userid) references tbl_member(userid)
    );
    
    /* drop table tbl_member_auth; */
    
    select * from tbl_member;
    select * from tbl_member_auth;
    
    commit;
    
    select userid username, userpw password, enabled
    from tbl_member
    where userid = 'admin90';
    
    select userid username, auth authority
    from tbl_member_auth
    where userid = 'admin90';
    
    SELECT mem.userid, userpw, username, enabled, regdate, updatedate, auth
		FROM tbl_member mem LEFT OUTER JOIN tbl_member_auth auth on mem.userid=auth.userid
		WHERE mem.userid = 'admin90';
        
    insert into tbl_member_auth(userid, auth) values('admin90', 'ROLE_MEMBER');
    
    create table persistent_logins (
        username varchar2(64) not null,
        series varchar2(64) primary key,
        token varchar2(64) not null,
        last_used timestamp not null
    );
    commit;
    
    select * from persistent_logins;