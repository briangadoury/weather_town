document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector('form');

  async function fetchWeather(url = '', data = {}) {
    let fetchUrl = url + '?' + new URLSearchParams(data);
    const response = await fetch(fetchUrl, {
      method: 'GET',
      cache: 'no-cache',
      headers: {
        'Content-Type': 'application/json',
      }
    });

    if (!response.ok) {
      console.log(response);
      throw new Error('Unexpected Backend Error');
    }

    return response.json();
  }

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const formInputs = form.getElementsByTagName('input');
    let formData = {};
    for (let input of formInputs) {
      formData[input.name] = input.value;
    }

    if (formData['zipcode'] === '') {
      return;
    }

    fetchWeather('/current_weather/fetch', formData)
      .then((data) => {
        console.log({ data });
        let ul = document.getElementById('results');
        let list = document.createDocumentFragment();

        Object.entries(data).forEach((entry) => {
          const [key, value] = entry;
          console.log(`${key}: ${value}`);
              let li = document.createElement('li');
              li.innerHTML = `<strong>${key}:</strong> ${value}`;
              list.appendChild(li);
        });

        //Remove any previous results and replace with new
        while(ul.firstChild) ul.removeChild(ul.firstChild);
        ul.appendChild(list);
      })
    .catch((err) => {
      alert(err)
    });
  });
});
