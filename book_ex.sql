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