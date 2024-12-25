export interface RequestInterface {
  operation: string;
}

export interface ResponseInterface {
  code: number,
  desc: string,
}

export interface AddResponseInterface extends ResponseInterface{
  data: []
}

export interface DeleteResponseInterface extends ResponseInterface{
  data: []
}

export interface LuggageInfoInterface {
  luggage_id: string,
  journey_id: string,
  name: string,
  create_timestamp: number,
  update_timestamp: number
}

export interface UserInfoInterface {
  uuid: string,
  phone_num: string,
  name: string,
  password: string
}

export interface JourneyInfoInterface {
  journey_id: string,
  uuid: string,
  name: string;
  destination: string;
  budget: number;
  num: number;
  start_date: string;
  end_date: string;
  create_timestamp: string,
  update_timestamp: string,
  status: number
}

export interface TripInfoInterface {
  journey_id: string,
  trip_id: string,
  spot: string;
  budget: number;
  minute: number;
  start_time: string;
  current_date: string;
  create_timestamp: string,
  update_timestamp: string,
  note: string
}