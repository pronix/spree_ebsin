= EBS Gateway

Require install to vendor/extension/ebsin_gateway

EBS Payment Gateway Extension  (www.ebs.in)

  Install and configure extension preferences:

  - preference account_id     = Get from your account
  - preference url            = https://secure.ebs.in/pg/ma/sale/pay/
  - preference secret_key     = Get from your account
  - preference mode           = 'LIVE' or 'TEST'
  - preference currency_code  = 'INR'

You can see messages plugin in the application log:

***************** EBS payment authorized on order R374461356 *****************
                 PaymentID       = 1190148
                 Mode            = TEST
                 DateCreated     = 2010-08-19 08:55:48
                 ResponseCode    = 0
                 MerchantRefNo   = R374461356
                 Amount          = 62.00
                 TransactionID   = 2288126
                 ResponseMessage = Transaction Successful
******************************************************************************

Thanks bryanmtl(http://github.com/bryanmtl), my work based on him clear2pay plugin

