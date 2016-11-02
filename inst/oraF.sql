

CREATE OR REPLACE
FUNCTION d2r( lat1 number, lon1 number) RETURN INTEGER IS
  reitur integer;
  lat real;
  lon real;
  BEGIN
	lat:=lat1/10000;
	lon:=lon1/10000;
	lat:=FLOOR(lat)+(lat-FLOOR(lat))/0.6;
	lon:=FLOOR(lon)+(lon-FLOOR(lon))/0.6;
	reitur:=FLOOR(lat)*100+FLOOR(lon)-6000;
	if ( (lat-FLOOR(lat)) > 0.5 ) then
                               reitur:=reitur+50;
        end if;
	RETURN reitur;
  END d2r;
/


CREATE OR REPLACE
FUNCTION postosmareit( lat1 number, lon1 number) RETURN INTEGER IS
  smareitur integer;
  lat real;
  lon real;
  reitur integer;
  BEGIN
	lat:=lat1/10000;
	lon:=lon1/10000;
	lat:=FLOOR(lat)+(lat-FLOOR(lat))/0.6;
	lon:=FLOOR(lon)+(lon-FLOOR(lon))/0.6;
	reitur:=FLOOR(lat)*100+FLOOR(lon)-6000;
	if ( (lat-FLOOR(lat)) > 0.5 ) then
                               reitur:=reitur+50;
        end if;
	lat := lat - floor(lat);
	lon := lon - floor(lon);
	if (lat > 0.5) then
	    lat := lat-0.5;
	end if;
	if (lat >= 0.25 and lon >= 0.5 ) then
            smareitur := 1;
	end if;
	if ( lat >= 0.25 and lon < 0.5 ) then
            smareitur := 2;
        end if;
        if ( lat < 0.25 and lon >= 0.5 ) then
       	    smareitur := 3;
        end if;
        if ( lat < 0.25 and lon < 0.5 ) then
            smareitur := 4;
        end if;
	RETURN smareitur;
  END postosmareit;
/


CREATE OR REPLACE
FUNCTION d2sr(lat1 number, lon1 number) RETURN INTEGER IS
  smareitur integer;
  reitur integer;
  reitar integer;

  BEGIN
    reitur := d2r(lat1, lon1);
    smareitur := postosmareit(lat1, lon1);
    if (reitur < 0) then
      reitar := reitur*10 - smareitur;
    else
      reitar := reitur*10 + smareitur;
    end if;

    RETURN reitar;
  END d2sr;
/

CREATE OR REPLACE
FUNCTION arcdist(lat number, lon number,lat1 number, lon1 number,nmi number) RETURN number IS
  mult1 number;
  mult2 number;
  rad number;
  miles number;
  dist number

  BEGIN
    if (nmi == 1) then
      miles := 1.852;
    else
      miles := 1;
    end if;
    rad := 6367;
    mult1 := rad/miles;
    mult2 := 3.141593/180;
    dist := mult1 * acos(sin(mult2 * lat) * sin(mult2 * lat1) + cos(mult2 * lat) * cos(mult2 * lat1) * cos(mult2 * lon - mult2 * lon1));

    RETURN dist;
  END arcdist;
/

CREATE OR REPLACE
FUNCTION geoconvert2(x number) RETURN number IS
  i number;
  p1 number;
  p2 number;
  p3 number;
  tmp number;
  lat number;

  BEGIN
    i := sign(x);
    lat := abs(x);
    p1 := floor(lat);
    p2 := floor((lat - p1)*60);
    p3 := floor((lat - p1 -p2/60)*100*60);
    tmp := i * (p1 * 10000 + p2 * 100 + p3);

    RETURN tmp;
  END geoconvert2;
/

CREATE OR REPLACE
FUNCTION geoconvert1(y number) RETURN number IS
  i number;
  x1 number;
  tmp number;
  x number;

  BEGIN
    i := sign(y);
    x := abs(y);
    x1 := mod(x,10000);
    tmp := (x/100)-trunc(x/10000)*100;
    tmp := (i*(x+(200/3)*tmp))/10000;
    RETURN tmp;
  END geoconvert1;
/
