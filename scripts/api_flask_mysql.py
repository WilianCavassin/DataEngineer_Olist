from flask import Flask
import pymysql

app = Flask(__name__)
app.secret_key = 'uss_enterprise'
conn = pymysql.connect(
    host='cavassin-olist.cheow94jgvzf.us-east-1.rds.amazonaws.com',
    port=3306,
    user='mysqlread',
    passwd='mysqlread',
    db='dados')

#exemplo, pode ser configurado via POST, via form, dependendo da premisse necessária
#algumas plataformas já fazem este preprocessamento
@app.route('/retrieve_translation', methods=['GET'])
#pode receber o form aqui->
def retrieve_translation():
    cursor = conn.cursor()
    statement = 'SELECT * FROM dados.product_category_name_translation '
    data = cursor.execute(statement)
    return(str(data))
#exemplo com Curitiba
def retrieve_cep():
    cursor = conn.cursor()
    statement = "SELECT geolocation_lat, geolocation_lng, city FROM dados.product_category_name_translation \
         WHERE city='Curitiba'"
    data = cursor.execute(statement)
    return(str(data))
#exemplo de insercao (dados vem via metodo POST)
#como sempre esses inserts podem ser dinamicos, assim como as querries
def insert_cep():
    try:
        cursor = conn.cursor()
        statement = "INSERT INTO dados.olist_geolocation_dataset (geolocation_zip_code_prefix, \
            geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) VALUES (80010,-12.20,-12.25,'Curitiba','PR')"
        cursor.execute(statement)
        return(statement+'\n inserido com sucesso')
    except:
        return('Erro na inserção')
if __name__ == '__main__':
    app.run(port=7520, debug=True)