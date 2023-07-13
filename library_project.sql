drop database if exists library;
create database library;
use library;
drop table if exists tbl_publisher;
create table tbl_publisher(publisher_publisherName varchar(100) primary key ,
publisher_publisherAddress varchar(100) not null,publisher_publisherPhone varchar(100) not null);
desc tbl_publisher;
drop table if exists tbl_book;
create table tbl_book(book_bookId int not null auto_increment,
book_title varchar(100)not null,
book_publisherName varchar(100) not null,
primary key(book_bookId),
foreign key(book_publisherName)
references tbl_publisher(publisher_publisherName)on delete cascade);
desc tbl_book;
drop table if exists tbl_book_authors;
create table tbl_book_authors(book_authors_authorId int not null auto_increment,
book_authors_bookId int not null,
book_authors_authorname varchar(100) not null,
primary key(book_authors_authorId),
foreign key(book_authors_bookId)
references tbl_book(book_bookId)on delete cascade);
desc tbl_book_authors;
drop table if exists tbl_librarybranch;
create table tbl_librarybranch(library_branch_branchId int primary key auto_increment,
library_branch_branchName varchar(100) not null,
library_branch_branchAddress varchar(100) not null); 
desc tbl_librarybranch;
drop table if exists tbl_book_copies;
create table tbl_book_copies(book_copies_copiesId int not null auto_increment,
book_copies_bookId int not null,
book_copies_branchId int not null,
book_copies_no_of_copies int not null,
primary key(book_copies_copiesId),
foreign key(book_copies_bookId)
references tbl_book(book_bookId),
foreign key(book_copies_branchId)
references tbl_librarybranch(library_branch_branchId)on delete cascade);
desc tbl_book_copies;
drop table if exists tbl_borrower;
create table tbl_borrower(borrower_cardno int primary key auto_increment,
borrower_borrowerName varchar(100)not null,
borrower_borrowerAddress varchar(100)not null,
borrower_borrowerphone varchar(100) not null);
desc tbl_borrower;
drop table if exists tbl_book_loans;
create table tbl_book_loans(book_loans_loansId int auto_increment,
book_loans_bookId int not null,
book_loans_branchId int not null,
book_loans_cardNo int not null,
book_loans_dateout date not null,
book_loans_duedate date not null,
primary key(book_loans_loansId),
foreign key(book_loans_bookId)
references tbl_book(book_bookId),
foreign key(book_loans_branchId)
references tbl_librarybranch(library_branch_branchId),
foreign key(book_loans_cardNo)
references tbl_borrower(borrower_cardNo)on delete cascade);
desc tbl_book_loans;

select * from tbl_publisher;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_librarybranch;
select * from tbl_book_copies;
select * from tbl_borrower;
select * from tbl_book_loans;

 -- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
 select * from tbl_book_copies;
 select * from tbl_librarybranch;
 select * from tbl_book;
 
 select b.book_title,l.library_branch_branchName,sum(c.book_copies_no_of_copies) as number_of_copies
 from tbl_book_copies as c
 join tbl_book as  b
 on c.book_copies_bookId = b.book_bookId
 join tbl_librarybranch as l
 on c.book_copies_branchId= l.library_branch_branchId
 where b.book_title ='The Lost Tribe' and l.library_branch_branchName = 'Sharpstown';
 
 ##########
 with cte1 as
(select b.book_title,c.book_copies_branchId,c.book_copies_no_of_copies
from tbl_book as b
join tbl_book_copies as c
on b.book_bookId= c.book_copies_bookId),
cte2 as
(select c1.book_title,c1.book_copies_no_Of_copies,c1.book_copies_branchId,lb.library_branch_branchName
from cte1 as c1
join tbl_librarybranch as lb
on c1.book_copies_branchId = lb.library_branch_branchId)
select  library_branch_branchName,book_title,book_copies_no_of_copies
 from cte2
 where book_title="The Lost Tribe" and library_branch_branchName = 'Sharpstown';
 ######
 
 

-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
 select b.book_title,l.library_branch_branchName,c.book_copies_no_of_copies
 from tbl_book_copies as c
 join tbl_book as  b
 on c.book_copies_bookId = b.book_bookId
 join tbl_librarybranch as l
 on c.book_copies_branchId= l.library_branch_branchId
 where b.book_title ='The Lost Tribe';
 
 ########
 with cte1 as
 (select b.book_title,c.book_copies_branchId,c.book_copies_no_of_copies
 from tbl_book_copies as c
 join tbl_book as  b
 on c.book_copies_bookId = b.book_bookId),
 cte2 as
 (select c1.book_title, c1.book_copies_no_of_copies,c1.book_copies_branchId,l.library_branch_branchId,l.library_branch_branchName
 from cte1 as c1
 join tbl_librarybranch as l
 on c1.book_copies_branchId= l.library_branch_branchId)
 select book_title,book_copies_branchId,book_copies_no_of_copies,library_branch_branchName
 from cte2 
 where book_title='The Lost Tribe';
 
 ########
 
-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select * from tbl_borrower;
select * from tbl_book_loans;

select borrower_cardno,borrower_borrowerName,book_loans_cardNo
from tbl_borrower as b
left join tbl_book_loans as l
on b.borrower_cardno = l.book_loans_cardNo
where l.book_loans_cardNo is null;

###### by using sub query
select b.borrower_borrowerName from tbl_borrower as b 
where b.borrower_cardno not in (select l.book_loans_cardNo from tbl_book_loans as l);

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address.
select * from tbl_book;
select * from tbl_book_loans;
select * from tbl_borrower;
select * from tbl_librarybranch;
 
select b.book_title, borrower_borrowerName, borrower_borrowerAddress
from tbl_book as b
join tbl_book_loans as l on  b.book_bookId =l.book_loans_bookId
join tbl_librarybranch as lb on l.book_loans_branchId = lb.library_branch_branchId
join tbl_borrower as br on l.book_loans_cardNo = br.borrower_cardno
where l.book_loans_duedate = '2/3/18' and lb.library_branch_branchName = 'Sharpstown';

########
with cte1 as
(select lb.library_branch_branchName, l.book_loans_bookId, l.book_loans_branchId, l.book_loans_cardNo,l.book_loans_duedate
from tbl_librarybranch as lb
join tbl_book_loans as l
on lb.library_branch_branchId = l.book_loans_branchId),
cte2 as
(select c1.library_branch_branchName, c1.book_loans_bookId, c1.book_loans_branchId, c1.book_loans_cardNo,c1.book_loans_duedate,b.book_title
from cte1 as c1
join tbl_book as b
on c1.book_loans_bookId = b.book_bookId),
cte3 as
(select  c2.library_branch_branchName, c2.book_loans_bookId, c2.book_loans_branchId, c2.book_loans_cardNo,c2.book_loans_duedate,c2.book_title, br.borrower_borrowerName, br.borrower_borrowerAddress
from cte2 as c2
join tbl_borrower as br)
select library_branch_branchName, book_loans_DueDate,book_title, borrower_borrowerName, borrower_borrowerAddress
from cte3
where library_branch_branchName= "Sharpstown" and book_loans_DueDate= '2018-03-02';

 
-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select * from tbl_book;
select * from tbl_book_loans;
select * from tbl_librarybranch;

select lb.library_branch_branchName, count(book_loans_bookId) as total
from tbl_book as b
join tbl_book_loans as l
on b.book_bookId = l.book_loans_bookId
join tbl_librarybranch as lb
on l.book_loans_branchId = lb.library_branch_branchId
group by lb.library_branch_branchName;


-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select * from tbl_borrower;
select * from tbl_book_loans;

select br.borrower_borrowerName, br.borrower_borrowerAddress, count(book_loans_bookId) as number_of_book_checked
from tbl_book as b
join tbl_book_loans l
on b.book_bookId = l.book_loans_bookId
join tbl_borrower as br
on l.book_loans_cardNo = br.borrower_cardno
group by br.borrower_borrowerName, br.borrower_borrowerAddress
having number_of_book_checked > 5;

#######
with cte1 as 
(select tlb.borrower_cardno,tlb.borrower_borrowerName,tlb.borrower_borrowerAddress,l.book_loans_bookId,l.book_loans_cardNo
from tbl_borrower as tlb
join tbl_book_loans as l
on tlb.borrower_cardNo = l.book_loans_cardno),
cte2 as
(select c1.borrower_borrowerName,c1.borrower_borrowerAddress,c1.book_loans_bookID,c1.book_loans_cardNo,b.book_title
from cte1 as c1
join tbl_book as b
on c1.book_loans_bookID= b.book_bookID)
select borrower_borrowerName, borrower_borrowerAddress , count(book_loans_bookId) as number_of_book_checked
from cte2
group by borrower_borrowerName, borrower_borrowerAddress
having number_of_book_checked > 5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select * from tbl_book_authors;
select * from tbl_book;
select * from tbl_book_copies;

select b.book_title, bcopy.book_copies_no_of_copies
from tbl_book as b
join tbl_book_authors as a
on b.book_bookid = a.book_authors_bookId
join tbl_book_copies as bcopy
on b.book_bookid = bcopy.book_copies_bookId
join tbl_librarybranch as lb
on bcopy.book_copies_branchId = lb.library_branch_branchId
where a.book_authors_authorname = 'Stephen King' and lb.library_branch_branchName = 'Central';

########
with cte1 as
(select b.book_bookId ,b.book_title, a.book_authors_AuthorID, a.book_authors_AuthorName
from tbl_book as b
join tbl_book_authors as a
on b.book_bookId = a.book_authors_bookId),
cte2 as
(select c1.book_bookId ,c1.book_title, c1.book_authors_AuthorId, c1.book_authors_authorname, bcopy.book_copies_branchId,bcopy.book_copies_no_of_copies
from cte1 as c1
join tbl_book_copies as bcopy
on c1.book_bookId = bcopy.book_copies_bookId),
cte3 as
(select c2.book_bookId ,c2.book_title, c2.book_authors_AuthorID, c2.book_authors_AuthorName, c2.book_copies_BranchID,c2.book_copies_no_of_copies,lib.library_branch_branchName
from cte2 as c2
join tbl_librarybranch as lib
on c2.book_copies_branchId = lib.library_branch_branchId)
select book_title,  book_authors_authorname,book_copies_no_of_copies,library_branch_branchName
from cte3
where book_authors_authorname= "Stephen King" and library_branch_branchName="Central";




