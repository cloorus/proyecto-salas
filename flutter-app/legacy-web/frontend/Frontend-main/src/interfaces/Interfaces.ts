// Data interfaces

export interface Person {
	ID_Person?: number;
	Identify: string;
	Name: string;
	Email: string;
	Tel: string;
	Address: string;
	Country: string;
	ID_Country?: number
	Cod_Reg?: string;
  };

export interface Role {
	ID_Role: number;
	Description: string;
};

export interface Country {
	ID_Country?: number;
	Name: string;
	Cod_Reg: string;
};

export interface UserPerson {
	ID_User: number;
	Username: string;
	Created_at: string;
};

export interface Engine {
	ID_Engine?: number;
	Model: string;
	Type: string;
	Brand: string;
	Link: string;
	PCB: string;
	ID_Type?: number;
  };

  export interface Membership {
	ID_Membership?: number;
	Name_Person: string;
	Identify_Person: string;
	Date_Payment: string,
	Date_Expiration: string;
	Type: number
  };

  export interface Training {
    ID_Training: number,
    Name_Person: string,
    Identify_Person: string,
    Type: string,
    Name: string,
    Description: string,
    Date: string,
	ID_Person?: number
};

export interface Activation {
	ID_Activation: number,
	ID_Installer: number,
	Name_Installer: string,
	Engine: string,
	ID_Vita: number,
	Date_Activation: string
};

export interface RolePerson {
	ID_Role?: number;
	ID_Role_Person?: number;
	ID_Person: number;
	Identify: string;
	Name: string;
	Role: string;
};

export interface EngineType {
	ID_Type?: number;
	Description: string;
};

export interface Validation {
	ID_Validation: number;
	Validated_Person: string,
	Validator_Person: string,
	Date_Validation: string;
};

export interface UserLogin {
	ID_Person: number;
	Username: string;
	ID_Role: number;
	Email: string
};