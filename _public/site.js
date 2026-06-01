const root = document.querySelector(":root")

const acc = {
	"R": "red",
	"Y": "yellow",
	"T": "teal",
	"P": "purple"
}

const inv = {
	"R": "teal",
	"Y": "blue",
	"T": "mulberry",
	"P": "yellow"
}

let swatches = []

function capitalize(s) {
    return String(s[0]).toUpperCase() + String(s).slice(1)
}

function toCol(c) {
	console.log("Changing to accent " + c)
	root.style.setProperty("--bg0", `var(--bg${c}0)`)
	root.style.setProperty("--bg1", `var(--bg${c}1)`)
	root.style.setProperty("--bg2", `var(--bg${c}2)`)
	root.style.setProperty("--bg3", `var(--bg${c}3)`)
	root.style.setProperty("--bg4", `var(--bg${c}4)`)
	root.style.setProperty("--bg5", `var(--bg${c}5)`)
	root.style.setProperty("--bg6", `var(--bg${c}6)`)
	root.style.setProperty("--fgDim", `var(--fg${c}Dim)`)
	root.style.setProperty("--bgRed", `var(--bg${c}Red)`)
	root.style.setProperty("--bgOrange", `var(--bg${c}Orange)`)
	root.style.setProperty("--bgYellow", `var(--bg${c}Yellow)`)
	root.style.setProperty("--bgGreen", `var(--bg${c}Green)`)
	root.style.setProperty("--bgTeal", `var(--bg${c}Teal)`)
	root.style.setProperty("--bgBlue", `var(--bg${c}Blue)`)
	root.style.setProperty("--bgLavender", `var(--bg${c}Lavender)`)
	root.style.setProperty("--bgPurple", `var(--bg${c}Purple)`)
	root.style.setProperty("--bgPink", `var(--bg${c}Pink)`)
	root.style.setProperty("--bgMulberry", `var(--bg${c}Mulberry)`)
	root.style.setProperty("--gray0", `var(--gray${c}0)`)
	root.style.setProperty("--gray1", `var(--gray${c}1)`)
	root.style.setProperty("--gray2", `var(--gray${c}2)`)

	root.style.setProperty("--accent", `var(--${acc[c]})`)
	root.style.setProperty("--bgAccent", `var(--bg${capitalize(acc[c])})`)
	root.style.setProperty("--invAccent", `var(--${inv[c]})`)
	root.style.setProperty("--vis", `var(--vis${c})`)

	if (document.readyState == "complete") { updateHexes() }
}

function toggleMode() {
	document.body.classList.toggle("light")

	if (document.readyState == "complete") { updateHexes() }
}

function loadSwatches() {
	swatches = document.querySelectorAll(".swatch")
	swatches.forEach(s => {
		const color = s.querySelector("span:first-of-type").innerHTML
		s.firstElementChild.style.setProperty("background-color", `var(--${color})`)
	})
}

async function updateHexes() {
	const vars = window.getComputedStyle(document.body)
	swatches.forEach(s => {
		const color = s.querySelector("span:first-of-type").innerHTML
		s.lastElementChild.innerHTML = vars.getPropertyValue(`--${color}`)
	})
}

// window.onload = toCol("P")
document.addEventListener("DOMContentLoaded", ev => {
	loadSwatches()
	updateHexes()
})