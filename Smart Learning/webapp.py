from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def retrieve():
    return file("usersAndScores.txt").read()

@app.route("/", methods=['POST'])
def index():
    username = request.form.get("user")
    password = request.form.get("password")
    letter = request.form.get("letter")
    score = request.form.get("score")

    print username 
    print password

    f = open("usersAndScores.txt", 'a')
    f.write(username+'/'+password+'/'+letter+'/'+score+'\n')
    f.close()
    return "True"

if __name__ == "__main__":
    app.run(debug = True)
