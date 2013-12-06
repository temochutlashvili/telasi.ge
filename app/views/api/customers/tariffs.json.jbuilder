json.id @customer.id
json.name @customer.custname.to_ka
json.number @customer.accnumb.to_ka
json.address @customer.address.to_s
json.accounts @customer.accounts.select { |x| x.statuskey == 0 } do |account|
  tariff = account.tariffs.last.tariff
  json.id account.acckey
  json.number account.accid.to_ka
  json.meter account.mtnumb
  json.address account.address.to_s
  json.tariff do
    json.id tariff.compkey
    json.name tariff.compname.to_ka
    json.amount tariff.amount
  end
end