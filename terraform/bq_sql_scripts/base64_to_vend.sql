CREATE OR REPLACE FUNCTION `${project_id}.${dataset}.base64_to_vend`(encoded_id string)
RETURNS string
AS
  ((
SELECT
   to_hex(substr(c.val,13,4))||'-'||
   to_hex(substr(c.val,11,2))||'-'||
   to_hex(substr(c.val,9,2))||'-'||
   to_hex(substr(c.val,7,2))||'-'||
   to_hex(substr(c.val,1,6))
FROM (SELECT from_Base64(encoded_id) AS val) AS c
  ));
