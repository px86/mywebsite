// Get an array of all source code blocks
const srcBlocks = document.querySelectorAll('.org-src-container');
const toggler = document.getElementById('toggler');
const navlist = document.querySelector('#preamble nav');

// Place the post date below the post title.
const date = document.getElementById('date');
const pageTitle = document.querySelector('#content > header');
pageTitle.appendChild(date);

let navVisible = (navlist.style.display === 'none');

toggler.addEventListener('click', () => {
  if (navVisible) {
    toggler.style.transform = 'unset';
    navlist.style.display = 'none';
    navVisible = false;
  } else {
    toggler.style.transform = 'rotate(-90deg)';
    navlist.style.display = 'block';
    navVisible = true;
  }
});

if (navigator.clipboard) {
  srcBlocks.forEach(elem => {
    const cpyBtn = document.createElement('button');
    cpyBtn.className = 'copy-btn';
    cpyBtn.addEventListener('click', () => {
      navigator.clipboard.writeText(elem.textContent);
    });
    addCopyBtnAnimation(cpyBtn);
    elem.appendChild(cpyBtn);
  });
}

function addCopyBtnAnimation(button) {
  const originalBgColor = button.style.backgroundColor;
  button.addEventListener('mousedown', () => {
    button.style.backgroundColor = '#87ceeb';
  });
  button.addEventListener('mouseup', () => {
    button.style.backgroundColor = originalBgColor;
  });
}
