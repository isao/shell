<?php
// populate dropdown menu
$slice = new smacSlice ($page, '<!-- selectbox_beg -->', '<!-- selectbox_end -->');
$sql = "SELECT id '{proto.id}', title '{proto.title}', IF(id=".$proto->id().",' selected=\'selected\'','') '{selected}'
				FROM proto
				ORDER BY title";
$proto->query ($sql);
while ($row = $proto->row ()) {
	if ($row['{proto.id}'] == $proto->id()) {
		$pagedata = $row;	// save for later
	}
	$slice->mixin ($row);	// see below
}

?>
<form action="{formaction}" method="get">
	<select id="id" name="id" size="1" onChange="submit()">
	<!-- selectbox_beg --><option value="{proto.id}"{selected}>{proto.title}</option>
	<!-- selectbox_end --></select>
	<noscript><input type="submit" value="change" /></noscript>
</form>
