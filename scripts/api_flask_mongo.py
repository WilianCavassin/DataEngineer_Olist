from flask import Flask
import pymongo

app = Flask(__name__)
app.secret_key = 'uss_enterprise'
client = pymongo.MongoClient("mongodb+srv://mongodbread:mongodbread@cluster0.hcjq9.mongodb.net/olist?retryWrites=true&w=majority")
db = client['olist']

#exemplo, pode ser configurado via POST, via form, dependendo da premisse necessária
#algumas plataformas já fazem este preprocessamento
@app.route('/retrieve_translation', methods=['GET'])
#pode receber o form aqui->
def retrieve_translation():    
    for doc in db.product_category_name_translation.find():
        print(doc)
    return ("Texto em prompt.")
#exemplo com Curitiba
@app.route('/retrieveCuritiba')
def retrieve_cep():
    for doc in db.olist_geolocation_dataset.find({"city" : 'Curitiba'},{"geolocation_lat": 1,	"geolocation_lng": 1,"city": 1}):
        print(doc)
    return("texto em prompt")
#exemplo de insercao (dados vem via metodo POST)
#como sempre esses inserts podem ser dinamicos, assim como as querries
@app.route('/insert_cep')
def insert_cep():
    try:
        statement = {"geolocation_zip_code_prefix": "80010","geolocation_lat":"-12.20", \
            "geolocation_lng":"-12.25","geolocation_city":"Curitiba","geolocation_state":"PR"}
        x = db.olist_geolocation_dataset.insert_one(statement)
        return(statement+'\n inserido com'+x.inserted_id)
    except:
        return('Erro na inserção')
if __name__ == '__main__':
    app.run(port=7520, debug=True)