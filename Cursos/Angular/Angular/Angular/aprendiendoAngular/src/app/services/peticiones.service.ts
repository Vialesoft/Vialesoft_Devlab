import { Injectable } from "@angular/core";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Observable } from "rxjs";

// /api/users/2
@Injectable()
export class PeticionesService {
    public url: string;
    public metodoGetUser = "/api/users/";
    constructor(
        public _http: HttpClient
    ) { 
        this.url = "https://reqres.in";
    }

    getUser(userId:any): Observable<any> {
        return this._http.get(this.url + this.metodoGetUser + userId);
    }

    addUser(user:any) :Observable<any>{
        let params = JSON.stringify(user);
        let headers = new HttpHeaders().set("Content-Type", "application/json");

        return this._http.post(this.url + this.metodoGetUser, params, {headers: headers});
    }
}


