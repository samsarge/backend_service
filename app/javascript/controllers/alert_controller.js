import { Controller } from 'stimulus'

export default class extends Controller {

  static targets = ['alert'];

  connect() {
    this._startTimerToFadeAlert();
  }

  async _startTimerToFadeAlert() {
    await this._wait(8000);
    this.alertTarget.classList.add('fade-out'); // fadeout takes 3 seconds after its added

    await this._wait(6000);
    this.alertTarget.remove();
  }

  async closeAlert() {
    this.alertTarget.remove();
  }

  // Sam what this is doing is just setting timers, so when it is used in the function above picture it as ruby code running each line one at time. Of course, your bro will probably have a better solution, but I think this is really readable.
   _wait(ms = 0) {
     return new Promise(resolve =>  setTimeout(resolve, ms));
   }

}
