import { useState } from 'react';

function IncidentReport() {
  const [apiState, setApiState] = useState(false);

  return (
    <div className="container mx-auto mt-10">
      <div className="w-1/2">
        <div className="bg-slate-100 border p-5">
          <form className="flex flex-col">
            <div className="flex flex-col my-2">
              <label className="text-sm">Titel</label>
              <input className="input" type="text" />
            </div>
            <div className="flex flex-col my-2">
              <label className="text-sm">Beskrivning</label>
              <textarea className="input" />
            </div>
            {apiState ? (
              <>
                <div className="flex flex-col my-2">
                  <label className="text-sm">Förare</label>
                  <select className="select">
                    <option value="">Unable to retrieve users.</option>
                  </select>
                </div>
                <div className="flex flex-col my-2">
                  <label className="text-sm">Steward</label>
                  <select className="select">
                    <option value="">Unable to retrieve users.</option>
                  </select>
                </div>
              </>
            ) : (
              <div className="bg-red-100 border border-red-500 p-3.5 text-sm">
                Kan inte hitta roller.
              </div>
            )}
            <div className="inline">
              <button className="bg-blue-700 text-white button">
                Skicka Rapport
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}

export default IncidentReport;
