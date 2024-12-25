import { RequestInterface,ResponseInterface, JourneyInfoInterface } from './common'

export interface AddJourneyInterface {
  id: string;
  uuid: string,
  name: string;
  destination: string;
  budget: number;
  num: number;
  start_date: string;
  end_date: string;
}

export interface AddJourneyRequestInterface extends RequestInterface {
  records: AddJourneyInterface
}

export interface QueryJourneyInterface {
  uuid: string,
  status: number
}

export interface QueryJourneyRequestInterface extends RequestInterface {
  records: QueryJourneyInterface
}

export interface QueryJourneyResponseInterface extends ResponseInterface {
  data: Array<JourneyInfoInterface>
}

export interface QueryJourneyInfoInterface {
  journey_id: string
}

export interface QueryJourneyInfoRequestInterface extends RequestInterface {
  records: QueryJourneyInfoInterface
}

export interface QueryJourneyInfoResponseInterface extends ResponseInterface {
  data: JourneyInfoInterface
}

export interface DeleteJourneyInterface {
  id: string
}

export interface DeleteJourneyRequestInterface extends RequestInterface {
  records: DeleteJourneyInterface
}