<?php require('includes/application_top.php');
define('EMAIL_SEPARATOR', '------------------------------------------------------');
if($_REQUEST['act']=='save') {
 $price_query = tep_db_query("insert into rfq_order_comment_history(order_id,customer_id,comments)values(".$_REQUEST['cID'].",".$_SESSION['customer_id'].",'".$_REQUEST['comment']."')");
 
 $order_query = tep_db_fetch_array(tep_db_query("select * from rfq_order where rfq_id = ".$_REQUEST['cID']." order by date_added desc"));
   $customer_id_tmp = $order_query['customer_id'];
$order_owner_id = $order_query['order_owner'];    
	    $rfq_id = ($_REQUEST['cID']);
	
		$email_order = "New comment added to " .strtoupper($order_query['order/quote']).'#'.$rfq_id. " \n" . " \n" . $_REQUEST['comment']. " \n" . " \n". 
		EMAIL_SEPARATOR . "\n\n" .	orderProductEmail($rfq_id) ."Added on:". date("Y-m-d").
                 
		
 		" \n" . " \n" . 'View Comment:' . "\n" .EMAIL_SEPARATOR . "\n<a href='http://itemnet.ca/staples/view_detail.php?id=" .$rfq_id. "'>http://itemnet.ca/staples/view_detail.php?id=" .$rfq_id. "</a>\n\n" ;
	   
	
	 
	// tep_mail($admin_address['customers_firstname'] . ' ' . $admin_address['customers_lastname'], $admin_address['customers_email_address'] ,"New comment  " .strtoupper($order_query['order/quote']).'#'.$rfq_id. "", $email_order, $customer_address['customers_firstname'] . ' ' . $customer_address['customers_lastname'], $customer_address['customers_email_address']);	 
//	tep_mail($customer_address['customers_firstname'] . ' ' . $customer_address['customers_lastname'], $customer_address['customers_email_address'], "New comment  " .strtoupper($order_query['order/quote']).'#'.$rfq_id. "", $email_order,$admin_address['customers_firstname'] . ' ' . $admin_address['customers_lastname'], $admin_address['customers_email_address'] );
   
	 
	 tep_mail(STORE_OWNER, STORE_OWNER_EMAIL_ADDRESS , "New comment  " .strtoupper($order_query['order/quote']).'#'.$rfq_id. "", $email_order,get_customer_fullname($_SESSION['customer_id']), get_customer_emailaddress($_SESSION['customer_id']));

 		tep_mail(get_customer_fullname($customer_id_tmp), get_customer_emailaddress($customer_id_tmp), "New comment  " .strtoupper($order_query['order/quote']).'#'.$rfq_id. "", $email_order, STORE_OWNER, STORE_OWNER_EMAIL_ADDRESS);
  
  if($order_owner_id!=0)
  {
	   tep_mail(get_customer_fullname($order_owner_id), get_customer_emailaddress($order_owner_id), "New comment  " .strtoupper($order_query['order/quote']).'#'.$rfq_id. "", $email_order, STORE_OWNER, STORE_OWNER_EMAIL_ADDRESS);

  }
   if($customer_id_tmp!=0)
  {
	   $customers_email = tep_db_query("select staples_admin from customers where customers_id = '" . (int)$customer_id_tmp. "'");
       $customer_address = tep_db_fetch_array($customers_email);
	   if($customer_address['staples_admin']!=0){
	   tep_mail(get_customer_fullname($customer_address['staples_admin']), get_customer_emailaddress($customer_address['staples_admin']), "New comment  " .strtoupper($order_query['order/quote']).'#'.$rfq_id. "", $email_order, STORE_OWNER, STORE_OWNER_EMAIL_ADDRESS);

	   }
  }
	
	
	        
         
 
 ?>
 <table width="100%" cellspacing="0" cellpadding="10" border="0">
  <tbody>
  <?php  $comment_his_sql = tep_db_query("select * from rfq_order_comment_history where order_id=".$_REQUEST['cID']."  order by date_added asc");
  while($comment_info = tep_db_fetch_array($comment_his_sql)) {
	  

 	  $gid = get_customer_geoup_id($comment_info['customer_id']); 
	  if(get_customer_type($gid)=='customer' || get_customer_type($gid)=='buyer')
	  { ?>
      	 <tr class="">
        	<th colspan="4" align="left">
                <h3 class="customer"><?=get_customer_fullname($comment_info["customer_id"])?></h3>
                <small>posted on: <?=date('d M, Y',strtotime($comment_info["date_added"]))?></small>
                <p><?=$comment_info["comments"]?></p>
          	</th>
      </tr>
 <?php } else {?>   
     	<tr class="">
        	<td colspan="4" align="left">
                <h3 class="customeradmin"><?=get_customer_fullname($comment_info["customer_id"])?>&nbsp;&nbsp;[<?php echo get_customer_group($gid) ?>]</h3>
                <small>posted on: <?=date('d M, Y',strtotime($comment_info["date_added"]))?></small>
                <p><?=$comment_info["comments"]?></p>
          	</td>
      </tr>
    <?php } }?>  
     
      <tr class="">
        <td colspan="4" align="left"><textarea name="comment_history" id="comment_history" cols="45" rows="5" placeholder="Add comment"></textarea></td>
        </tr>
     <tr class="">
        <td colspan="4" align="left"><div id="loader"><img src="images/opc-ajax-loader.gif" /></div> <input type="button" name="Order" id="Order" value="Save comment" class="myButton" onclick="updateComment();" /></td>
        </tr>
        </tbody></table>         
<?php
}
?>