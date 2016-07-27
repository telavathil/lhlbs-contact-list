# Homepage (Root path)
get '/' do
  erb :index
end

get '/contacts' do
  @contactsJson = Contact.all.as_json
  json @contactsJson
end

post '/contact/new' do

  contact = Contact.new.from_json(params.to_json)

  contact.save
  @contactsJson = Contact.last.as_json
  json @contactsJson
end

get '/contact/:id' do
  #json for one contact
  @contactJson = Contact.find(params[:id]).as_json
  json @contactJson
end

post '/contact/delete/:id' do
  contact = Contact.find(params[:id])
  contact.destroy

  @contactsJson = Contact.all.as_json
  json @contactsJson
end

post '/contact/edit/:id' do
  contact = Contact.find(params[:id])
  data = params.slice('firstname','lastname','email','phone1','phone2')
  contact.update(data)

  @contactJson = Contact.find(params[:id]).as_json
  json @contactJson
end
